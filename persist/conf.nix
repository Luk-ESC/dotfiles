{
  persist.users = [ "eschb" ];

  persist.location.data.contents = [
    "/var/lib/nixos/"
    "/etc/machine-id"
  ];

  persist.location.caches.contents = [
    "/var/cache/"

    # sudo: saves first time using sudo
    "/var/db/sudo/lectured/"
  ];

  persist.location.logs.contents = [
    "/var/log/"
  ];
}
