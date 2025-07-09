{ config, lib, options, pkgs, ... }: {
  imports = [ ./base.nix ./persist/persist.nix ];

  networking.hostName = lib.mkForce "nixos";

  services.getty.autologinUser = "eschb";
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;

  security.pam.services.hyprlock = {};

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
    packages = with pkgs;
      [
        (vesktop.overrideAttrs (finalAttrs: oldAttrs: {
          postUnpack = ''
            cp ${./custom_vesktop.gif} $sourceRoot/static/shiggy.gif

            ${oldAttrs.postUnpack or ""}
          '';
        }))
      ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ nano git wget ];

  environment.variables.EDITOR = "nano";
}
