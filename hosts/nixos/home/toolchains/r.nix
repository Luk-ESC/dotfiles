{ pkgs, ... }:
let
  packages = with pkgs.rPackages; [
    languageserver
    tidyverse
    patchwork
    ggplot2
  ];
  wrapper = pkgs.rWrapper.override {
    inherit packages;
  };
  rstudio = pkgs.rstudioWrapper.override {
    inherit packages;
  };
in
{
  programs.helix.extraPackages = [ wrapper ];
  home.packages = [
    wrapper
    rstudio
  ];

  atlas.rstudio.enable = true;
}
