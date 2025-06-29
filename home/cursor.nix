{ config, pkgs, ... }: {
  home.pointerCursor = {
    package = pkgs.rose-pine-hyprcursor;
    name = "rose-pine-hyprcursor";
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = true;
  };
}
