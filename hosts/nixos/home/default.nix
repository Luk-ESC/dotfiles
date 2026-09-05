{ config, ... }:
{
  imports = [
    ./apps
    ./term
    ./toolchains
    ./tools
    ./wm

    ./lockin.nix
  ];

  xresources.path = "${config.xdg.configHome}/.Xresources";
}
