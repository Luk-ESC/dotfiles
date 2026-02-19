{ config, age, ... }:
{
  imports = [
    ./apps
    ./term
    ./toolchains
    ./tools
    ./wm

    ./lockin.nix
    ./wlsunset.nix
  ];

  home.packages = [ age ];

  home.username = "eschb";
  home.homeDirectory = "/home/eschb";

  persist.data.contents = [
    "Music/"
    "Pictures/"
    "Documents/"
    "Videos/"
    "ZedProjects/"

    # NixOS config
    "nixcfg/"
  ];

  persist.caches.contents = [
    ".cache/"
  ];

  persist.session.contents = [
    # Audio
    ".config/pulse/"
    ".local/state/wireplumber/"
    ".local/share/waydroid/"
  ];

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
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
