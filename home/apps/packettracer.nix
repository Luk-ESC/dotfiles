{ pkgs, ... }:
{
  home.packages = [
    (pkgs.callPackage ../../pkgs/packetTracer.nix { })
  ];
}
