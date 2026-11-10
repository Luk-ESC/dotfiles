{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      terminal.shell.program = "zsh";
      cursor.style.shape = "Beam";
    };
  };
}
