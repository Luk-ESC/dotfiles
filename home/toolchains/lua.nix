{ pkgs, ... }:
{
  programs.helix = {
    extraPackages = [
      pkgs.lua-language-server
    ];
  };
}
