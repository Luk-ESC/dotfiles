{ config, age, ... }:
{
  imports = [
    ./apps
    ./term
    ./toolchains
    ./tools
    ./wm

    ./lockin.nix
  ];

  programs.leaves = {
    enable = true;
    settings.exclude_current = "current";
  };

  home.packages = [ age ];

  home.username = "eschb";
  home.homeDirectory = "/home/eschb";

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    desktop = null;
    publicShare = null;
    templates = null;
  };

  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  xresources.path = "${config.xdg.configHome}/.Xresources";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
