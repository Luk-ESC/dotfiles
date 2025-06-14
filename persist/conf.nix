{
  persist.users.eschb = "/home/eschb";

  persist.location.data.contents = [
    # System
    "/var/lib/nixos/"
    "/etc/nixos/"
    "/etc/machine-id"

    # User data
    "Music/"
    "Pictures/"
    "Documents/"
    "Videos/"

    # Keys (TODO: Fix permissions)
    ".gnupg/"
    ".ssh/"
    ".local/share/keyrings/"

    # ZEDITOR:
    ".local/share/zed/"

  ];

  persist.location.caches.contents = [
    "/var/cache/"
    ".cache/"

    # ZEDITOR:
    ".local/share/zed/node/cache/"

    # ZSH
    ".zcompdump"
  ];

  persist.location.logs.contents = [
    "/var/log/"

    # ZEDITOR:
    ".local/share/zed/node/cache/_logs/"
    ".local/share/zed/logs/"
  ];
}
