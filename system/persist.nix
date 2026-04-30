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
}
