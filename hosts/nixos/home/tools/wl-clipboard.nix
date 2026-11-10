{ lib, pkgs, ... }:
{
  home.packages =
    let
      wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
    in
    with pkgs;
    [
      wl-clipboard
      (writeShellScriptBin "cope" ''
        realpath $1 | tr -d '\n' | ${wl-copy}
      '')
    ];
}
