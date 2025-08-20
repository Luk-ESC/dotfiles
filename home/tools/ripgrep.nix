{ lib, pkgs, ... }:
{
  programs.ripgrep.enable = true;
  home.shellAliases.grep = lib.getExe pkgs.ripgrep;
}
