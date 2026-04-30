{ pkgs, ... }:
{
  home.packages = [
    pkgs.wineWowPackages.waylandFull
  ];
}
