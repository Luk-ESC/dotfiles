{
  persist.users.eschb = "/home/eschb";

  persist.location.data.contents = [
    # System
    "/var/lib/nixos/"
    "/etc/machine-id"

    # User data
    "Music/"
    "Pictures/"
    "Documents/"
    "Videos/"

    # NixOS config
    "nixcfg/"

    # Keys (TODO: Fix permissions)
    ".gnupg/"
    ".ssh/"
    ".local/share/keyrings/"

    # ZEDITOR:
    ".local/share/zed/"

    # Binary ninja:
    ".config/Vector 35/Binary Ninja.conf"
    ".binaryninja/"

    # Firefox
    ".mozilla/"

    # GeoGebra
    ".pki/"
    ".config/GeoGebra/"
  ];

  persist.location.caches.contents = [
    "/var/cache/"
    ".cache/"

    # ZEDITOR:
    ".local/share/zed/node/cache/"

    # ZSH
    ".zcompdump"

    # HYPRLAND
    ".local/share/hyprland/lastVersion"

    # sudo: saves first time using sudo
    "/var/db/sudo/lectured/"
  ];

  persist.location.logs.contents = [
    "/var/log/"

    # ZEDITOR:
    ".local/share/zed/node/cache/_logs/"
    ".local/share/zed/logs/"
  ];
}
