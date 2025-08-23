{ pkgs, ... }:
{
  services.podman.enable = true;

  home.packages = [ pkgs.podman-compose ];

  persist.caches.contents = [
    ".local/share/containers/cache/"
  ];

  persist.data.contents = [
    ".local/share/containers/storage/"
  ];
}
