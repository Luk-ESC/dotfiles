{
  ida91,
  pkgs,
  lib,
  minimal,
  ...
}:
{
  # GUI Apps
  imports = [
    ./firefox.nix
    ./vesktop.nix
  ]
  ++ (lib.optionals (!minimal) [
    ./warp.nix
  ]);

  home.packages = lib.optionals (!minimal) (
    with pkgs;
    [
      steam
      teams-for-linux
      retroarch-free
      prismlauncher
      (callPackage ../../pkgs/packetTracer.nix { })
      mysql-workbench
      mattermost-desktop
      maltego
      ida91
      geogebra6
      dbeaver-bin
      burpsuite
      binaryninja-free
    ]
  );
}
