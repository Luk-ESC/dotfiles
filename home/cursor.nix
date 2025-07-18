{ pkgs, ... }:
{
  home.pointerCursor = {
    package = pkgs.rose-pine-hyprcursor;
    name = "rose-pine-hyprcursor";
    size = 32;
    gtk.enable = true;
    hyprcursor.enable = true;
  };
}
