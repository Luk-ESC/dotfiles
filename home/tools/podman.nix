{ pkgs, ... }:
{
  services.podman.enable = true;

  home.packages = [ pkgs.podman-compose ];
}
