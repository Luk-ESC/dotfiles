{ config, lib, ... }:
let
  themeDirectory = "${config.xdg.dataHome}/icons/${config.home.pointerCursor.name}";
  themeFile = config.home.file.${themeDirectory};
in
{
  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    dotIcons.enable = false;
  };

  # Link the theme before Niri/GTK update, so Niri cannot cache a missing theme.
  home.activation.linkCursorTheme =
    lib.hm.dag.entryBetween [ "dconfSettings" "linkGeneration" ] [ "writeBoundary" "checkFilesChanged" ]
      ''
        run mkdir -p ${lib.escapeShellArg (dirOf themeDirectory)}
        run ln -Tsf ${lib.escapeShellArg "${config.home-files}/${themeFile.target}"} ${lib.escapeShellArg themeDirectory}
      '';
}
