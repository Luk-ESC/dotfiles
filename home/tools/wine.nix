{ pkgs, ... }:
{
  home.packages = [
    pkgs.wineWowPackages.waylandFull
  ];

  persist.caches.contents = [
    ".wine/"
  ];
}
