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
    ./bottom.nix
    ./fastfetch.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./ni.nix
    ./ripgrep.nix
    ./ssh.nix
    ./switchwall.nix
    ./s.nix
    ./tealdeer.nix
    ./wl-clipboard.nix
    ./zellij.nix
  ]
  ++ (lib.optionals (!minimal) [
    ./podman.nix
    ./wine.nix
    ./codex.nix
  ]);

  home.packages =
    with pkgs;
    [
      (unp.override {
        extraBackends = [ unrar ];
      })
      unixtools.netstat
      file
      netcat
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
