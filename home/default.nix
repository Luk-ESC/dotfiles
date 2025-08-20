{
  imports = [
    ./apps
    ./term
    ./tools
    ./wm

    ./borgmatic.nix
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

  persist.session.contents = [
    # Audio
    ".config/pulse/"
    ".local/state/wireplumber/"
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
