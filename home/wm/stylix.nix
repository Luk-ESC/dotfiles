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
  stylix.image = lib.mkDefault ../../assets/wallpaper.jpg;

  specialisation = lib.mergeAttrsList (
    map (x: {
      ${specName x}.configuration.stylix.image = x;
    }) images
  );

  home.shellAliases = lib.mergeAttrsList (
    map (x: {
      "switch-${specName x}" =
        config.home.homeDirectory
        + "/.local/state/home-manager/gcroots/current-home/specialisation/${specName x}/activate";
    }) images
  );

  stylix.fonts.monospace = {
    name = "MesloLGM Nerd Font";
    package = pkgs.nerd-fonts.meslo-lg;
  };

  stylix.cursor = {
    name = "rose-pine-hyprcursor";
    package = pkgs.rose-pine-hyprcursor;
    size = 32;
  };

  stylix.opacity.terminal = 0.5;
  stylix.polarity = "dark";

  stylix.overlays.enable = false;
}
