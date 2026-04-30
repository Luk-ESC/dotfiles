{ pkgs, ... }:
{
  home.packages = [ pkgs.go ];

  programs.helix.extraPackages = [ pkgs.gopls ];
}
