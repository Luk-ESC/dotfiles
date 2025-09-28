{ pkgs, ... }:
let
  packages = with pkgs.rPackages; [
    languageserver
    tidyverse
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

  persist.session.contents = [
    ".config/RStudio/"
    ".local/share/rstudio/"
  ];
}
