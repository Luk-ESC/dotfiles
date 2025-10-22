{
  programs.zellij = {
    enable = true;

    settings = {
      show_startup_tips = false;
      show_release_notes = false;
      default_shell = "zsh";

      on_force_close = "quit";
      scroll_buffer_size = 100000;

      ui.pane_frames.rounded_corners = true;
    };
  };
}
