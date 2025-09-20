{ pkgs, pwndbg, ... }:
{
  # Terminal tools
  imports = [
    ./bottom.nix
    ./fastfetch.nix
    ./file.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./podman.nix
    ./ripgrep.nix
    ./ssh.nix
    ./tealdeer.nix
    ./wine.nix
    ./wl-clipboard.nix
    ./zellij.nix
  ];

  home.packages = with pkgs; [
    unp
    unzip
    snicat
    netcat
    wireguard-tools
    qemu
    gcc
    pwndbg
    xxd
  ];
}
