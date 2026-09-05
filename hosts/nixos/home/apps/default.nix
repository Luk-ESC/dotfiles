{
  ida,
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
    ./prismlauncher.nix
    ./warp.nix
  ]);

  home.packages = lib.optionals (!minimal) (
    with pkgs;
    [
      steam
      teams-for-linux
      retroarch-free
      (callPackage ../../../../pkgs/packetTracer.nix { })
      mysql-workbench
      mattermost-desktop
      maltego
      ida
      geogebra6
      dbeaver-bin
      burpsuite
      binaryninja-free
    ]
  );
}
