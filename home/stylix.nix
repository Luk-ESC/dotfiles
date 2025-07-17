{ pkgs, ... }: {
  stylix.enable = true;
  stylix.image = ../assets/wallpaper.jpg;

  stylix.fonts.monospace = {
    name = "MesloLGM Nerd Font";
    package = pkgs.nerd-fonts.meslo-lg;
  };

  stylix.opacity.terminal = 0.5;
  stylix.polarity = "dark";
}
