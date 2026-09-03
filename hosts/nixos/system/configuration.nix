{
  minimal,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./howdy.nix
    ./waydroid.nix
  ];

  services.upower.enable = true; # Noctalia

  users.users.eschb.extraGroups = [
    "video"
    "wireshark"
  ];

  boot.loader.limine.style =
    let
      inherit (config.lib.stylix) colors;
      opacity = "c0";
    in
    {
      wallpapers = [ config.stylix.image ];
      interface.branding = "you wouldnt steal a car";
      graphicalTerminal = {
        palette = lib.concatStringsSep ";" [
          colors.base00
          colors.red
          colors.green
          colors.brown
          colors.blue
          colors.magenta
          colors.cyan
          colors.base04
        ];
        brightPalette = lib.concatStringsSep ";" [
          colors.base01
          colors.bright-red
          colors.bright-green
          colors.yellow
          colors.bright-blue
          colors.bright-magenta
          colors.bright-cyan
          colors.base07
        ];
        foreground = colors.base05;
        background = "${opacity}${colors.base00}";
        brightForeground = colors.base06;
        brightBackground = colors.base02;
      };
    };

  xdg.portal.extraPortals = lib.mkForce [
    pkgs.xdg-desktop-portal-gtk
  ];

  networking.hostName = lib.mkForce "nixos";

  hardware.bluetooth.enable = true;

  programs.nix-ld.enable = true;

  services.getty.autologinUser = "eschb";
  services.getty.autologinOnce = true;

  programs.wireshark = {
    enable = !minimal;
    package = pkgs.wireshark;
  };

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

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
}
