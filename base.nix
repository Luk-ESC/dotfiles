{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix # TODO: Does this make sense here??
  ];

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos_base";
  networking.networkmanager = {
    enable = true;
    ensureProfiles.profiles = {
      "L Diablo" = {
        connection = {
          id = "L Diablo";
          type = "wifi";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "L Diablo";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "ichhabfomo";
        };
      };
    };
  };

  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  virtualisation = let
    options = {
      virtualisation.memorySize = 8192;
      virtualisation.graphics = true;
      virtualisation.cores = 6;
    };
  in {
    vmVariant = options;
    # TODO: Make this work, iso image does not have disko
    #vmVariantWithDisko = {
    #  imports = [options];
    #};
  };

  services.speechd.enable = lib.mkForce false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eschb = {
    isNormalUser = true;
    initialPassword = "lol";
    extraGroups = ["wheel" "video"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano
    git
    wget
  ];

  environment.variables.EDITOR = "nano";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "25.05"; # Dont change idiot
}
