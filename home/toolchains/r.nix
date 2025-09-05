{ pkgs, ... }:
let
  wrapper = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [ languageserver ];
  };
in
{
  programs.helix.extraPackages = [ wrapper ];
  home.packages = [ wrapper ];
}
