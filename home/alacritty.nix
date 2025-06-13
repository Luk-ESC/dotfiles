{ config, pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      font.size = 13.5;
      terminal.shell.program = "zsh";
      window.opacity = 0.5;
      cursor.style.shape = "Beam";

      font.normal = {
        family = "MesloLGM Nerd Font";
        style = "Regular";
      };
    };
  };
  home.packages = [ pkgs.nerd-fonts.meslo-lg ];
}
