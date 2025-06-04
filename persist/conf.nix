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
  ];

  persist.location.caches.contents = [
    "/var/cache/"
    ".cache/"

    # ZSH
    ".zcompdump"
  ];

  persist.location.logs.contents = [
    "/var/log/"
  ];
}
