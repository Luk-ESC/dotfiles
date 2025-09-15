{ lib, pkgs, ... }:
{
  imports = [
    ./base.nix
    ./persist/persist.nix
  ];

  networking.hostName = lib.mkForce "nixos";

  hardware.bluetooth.enable = true;
  persist.location.session.contents = [
    "/var/lib/bluetooth/"
  ];

  programs.nix-ld.enable = true;

  services.getty.autologinUser = "eschb";

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  niri-flake.cache.enable = false;

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  security.pam.services.hyprlock = { };

  virtualisation =
    let
      options = {
        virtualisation.memorySize = 8192;
        virtualisation.graphics = true;
        virtualisation.cores = 6;
      };
    in
    {
      vmVariant = options;
      vmVariantWithDisko = options;
    };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Disable nano
  programs.nano.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
}
