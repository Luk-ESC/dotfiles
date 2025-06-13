{ config, lib, options, pkgs, ... }: {
  imports = [ ./base.nix ./persist/persist.nix ];

  networking.hostName = lib.mkForce "nixos";

  persist.users.sddm = "/var/lib/sddm";
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  systemd.services."set-etc-nixos-perms" = {
    description = "Set /etc/nixos permissions for wheel group";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "set-etc-nixos-perms" ''
        chgrp -R wheel /etc/nixos
        chmod -R 770 /etc/nixos
      '';
    };
  };

  virtualisation = let
    options = {
      virtualisation.memorySize = 8192;
      virtualisation.graphics = true;
      virtualisation.cores = 6;
    };
  in {
    vmVariant = options;
    vmVariantWithDisko = options;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages;
    [
      ark
      elisa
      plasma-browser-integration
      gwenview
      okular
      kate
      khelpcenter
      dolphin
      baloo-widgets
      dolphin-plugins
      ffmpegthumbs
      xwaylandvideobridge
    ] ++ (lib.optionals (!(options.virtualisation ? qemu)) [ konsole ]);

  services.speechd.enable = lib.mkForce false;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eschb = {
    isNormalUser = true;
    initialPassword = "lol";
    extraGroups = [ "wheel" "video" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ nano git wget ];

  environment.variables.EDITOR = "nano";
}
