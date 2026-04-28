{ pkgs, ... }:
{
  home.packages = [ pkgs.mysql-workbench ];

  atlas.mysql-workbench.enable = true;
}
