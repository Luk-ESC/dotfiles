{
  persist.users = [ "eschb" ];

  persist.location.data.contents = [
    "/var/lib/nixos/"
    "/etc/machine-id"
  ];

  persist.location.caches.contents = [
    "/var/cache/"
  ];

  persist.location.logs.contents = [
    "/var/log/"
  ];

  persist.location.session.contents = [
    # sudo: saves first time using sudo
    "/var/db/sudo/lectured/"
  ];
}
