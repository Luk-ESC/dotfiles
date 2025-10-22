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
  boot.loader.systemd-boot.enable = true;
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
    # Bloat that is only needed for vpns, pulls in webkit2gtk for some reason
    # FIXME(2025.11) enableDefaultPlugins = true;
    plugins = lib.mkForce [ pkgs.networkmanager-openvpn ];
    ensureProfiles = {
      environmentFiles = [ config.age.secrets.wireless.path ];
      profiles = {
        "L Diablo" = {
          connection = {
            id = "L Diablo";
            type = "wifi";
          };
          ipv4.method = "auto";
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "L Diablo";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$psk_ldiablo";
          };
        };

        mfzsguest = {
          connection = {
            id = "mfzsguest";
            type = "wifi";
          };
          ipv4.method = "auto";
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "mfzsguest";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$psk_hannah";
          };
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

  system.rebuild.enableNg = true;

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
