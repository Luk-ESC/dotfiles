{
  pkgs,
  lib,
  config,
  wallpapers,
  ...
}:
let
  specName =
    a:
    "wallpaper-"
    + builtins.head (lib.splitString "." (builtins.baseNameOf (builtins.unsafeDiscardStringContext a)));
  images = lib.filesystem.listFilesRecursive wallpapers.outPath;
in
{
  stylix.enable = true;
  stylix.image = lib.mkDefault (wallpapers.outPath + "/default");

  specialisation = lib.mergeAttrsList (
    map (x: {
      ${specName x}.configuration.stylix.image = x;
    }) images
  );

  home.activation.writeGenerationPath = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run dirname "$0" >> ~/.cache/hm_generations
  '';

  stylix.fonts.monospace = {
    name = "MesloLGM Nerd Font";
    package = pkgs.nerd-fonts.meslo-lg;
  };

  stylix.cursor =
    with config.lib.stylix.colors.withHashtag;
    let
      themeName = "Bibata-Stylix-" + (specName config.stylix.image);
    in
    {
      name = themeName;
      package = pkgs.callPackage ../../pkgs/bibata.nix {
        baseColor = base00;
        outlineColor = base0C;
        cursorThemeName = themeName;
      };
      size = 24;
    };

  stylix.opacity.terminal = 0.6;
  stylix.polarity = "dark";

  stylix.overlays.enable = false;
}
