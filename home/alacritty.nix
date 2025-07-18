{ ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      terminal.shell.program = "zsh";
      cursor.style.shape = "Beam";
    };
  };
}
