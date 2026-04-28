{ pkgs, ... }:
{
  home.packages = [ pkgs.maltego ];
  atlas.maltego.enable = true;
}
