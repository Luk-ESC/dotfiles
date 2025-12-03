{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix # TODO: Does this make sense here??
  ];

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.channel.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.limine =
    let
      inherit (config.lib.stylix) colors;
      opacity = "c0";
    in
    {
      enable = true;
      maxGenerations = 5;
      style = {
        wallpapers = [ config.stylix.image ];
        # backdrop = colors.base00;
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
    };
  boot.loader.efi.canTouchEfiVariables = true;

  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  networking.hostName = "nixos_base";
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
  };

  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
    # useXkbConfig = true; # use xkb.options in tty.
  };

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
      # TODO: Make this work, iso image does not have disko
      #vmVariantWithDisko = {
      #  imports = [options];
      #};
    };

  services.speechd.enable = lib.mkForce false;

  users.mutableUsers = false;
  users.users.eschb = {
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.linuxpw.path;
    extraGroups = [
      "wheel"
      "video"
      "wireshark"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Dont change idiot
}
