{
  lib,
  pkgs,
  ...
}:
{
  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.use-xdg-base-directories = true;

  nix.channel.enable = false;

  boot.loader.limine = {
    enable = true;
    maxGenerations = 5;
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

  programs.bash.enable = false;
  programs.zsh.enable = true;

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Dont change idiot
}
