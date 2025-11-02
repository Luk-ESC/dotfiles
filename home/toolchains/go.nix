{ pkgs, ... }:
{
  home.packages = [ pkgs.go ];

  programs.helix.extraPackages = [ pkgs.gopls ];

  home.sessionVariables.GOPATH = "/persistent/caches/home/eschb/go/";
}
