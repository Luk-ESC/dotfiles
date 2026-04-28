{ pkgs, ... }:
{
  home.packages = [ pkgs.steam ];

  atlas.steam.enable = true;
}
