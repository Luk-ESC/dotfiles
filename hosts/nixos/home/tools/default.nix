{
  minimal,
  lib,
  pkgs,
  pwndbg,
  ...
}:
{
  # Terminal tools
  imports = [
    ./switchwall.nix
    ./s.nix
    ./wl-clipboard.nix
  ]
  ++ (lib.optionals (!minimal) [
    ./wine.nix
    ./codex.nix
  ]);

  home.packages =
    with pkgs;
    [
      pulsemixer
    ]
    ++ (lib.optionals (!minimal) [
      snicat
      qemu
      gcc
      pwndbg
      xxd
      imagemagick
      nmap
    ]);
}
