{ lib, minimal, ... }:
{
  # GUI Apps
  imports = [
    ./firefox.nix
    ./vesktop.nix
  ]
  ++ (lib.optionals (!minimal) [
    ./binja.nix
    ./burpsuite.nix
    ./dbeaver.nix
    ./geogebra.nix
    ./ida.nix
    ./maltego.nix
    ./mattermost.nix
    ./mysql-workbench.nix
    ./packettracer.nix
    ./prismlauncher.nix
    ./retroarch.nix
    ./teams-for-linux.nix
    ./warp.nix
  ]);
}
