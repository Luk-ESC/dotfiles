{
  programs.zellij = {
    enable = true;

    settings = {
      show_startup_tips = false;
      show_release_notes = false;
      default_shell = "zsh";
      ui.pane_frames.rounded_corners = true;
    };
  };
}
