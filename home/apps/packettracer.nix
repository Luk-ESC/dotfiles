{ pkgs, ... }:
{
  home.packages = [
    (pkgs.callPackage ../../pkgs/packetTracer.nix { })
  ];

  atlas.packettracer.enable = true;
}
