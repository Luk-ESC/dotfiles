{
  persist.users = [ "eschb" ];

  persist.location.data.contents = [
    "/var/lib/nixos/"
    "/etc/machine-id"
    "/etc/ssh/"
  ];

  persist.location.caches.contents = [
    "/var/cache/"
  ];

  persist.location.logs.contents = [
    "/var/log/"
  ];
}
