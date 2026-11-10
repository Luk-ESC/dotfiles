{ pkgs, ... }:
{
  home.packages = [
    pkgs.wineWow64Packages.waylandFull
  ];
}
