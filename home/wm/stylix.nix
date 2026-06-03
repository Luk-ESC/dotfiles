{
  pkgs,
  lib,
  config,
  assets,
  ...
}:
let
  specName =
    a:
    "wallpaper-"
    + builtins.head (lib.splitString "." (builtins.baseNameOf (builtins.unsafeDiscardStringContext a)));
  images = lib.filesystem.listFilesRecursive (assets.outPath + "/wallpapers");
in
{
  stylix.enable = true;
  stylix.image = lib.mkDefault (assets.outPath + "/wallpapers/default");

  specialisation = lib.mergeAttrsList (
    map (x: {
      ${specName x}.configuration.stylix.image = x;
    }) images
  );

  stylix.targets = {
    blender.enable = false;
    kde.enable = false;
    gtk.flatpakSupport.enable = false; # edits ~/.themes/adw-gtk3
  };

  home.activation.writeGenerationPath = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run dirname "$0" >> ~/.cache/hm_generations
  '';

  stylix.fonts.monospace = {
    name = "MesloLGSNF";
    package = pkgs.meslo-lgs-nf;
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
  stylix.opacity.desktop = 0.93;
  stylix.polarity = "dark";

  stylix.overlays.enable = false;
}
