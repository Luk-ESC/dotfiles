{ ... }:
{
  imports = [
    ./zed.nix
    ./alacritty.nix
    ./binja.nix
    ./baobab.nix
    ./zsh.nix
    ./starship.nix
    ./cursor.nix
    ./firefox.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./geogebra.nix
    ./git.nix
    ./ssh.nix
    ./stylix.nix
    ./vesktop.nix
  ];

  home.username = "eschb";
  home.homeDirectory = "/home/eschb";

  persist.data.contents = [
    "Music/"
    "Pictures/"
    "Documents/"
    "Videos/"

    # NixOS config
    "nixcfg/"
  ];

  persist.caches.contents = [
    ".cache/"
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
