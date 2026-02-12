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
    ./tealdeer.nix
    ./wl-clipboard.nix
    ./zellij.nix
  ]
  ++ (lib.optionals (!minimal) [
    ./podman.nix
    ./wine.nix
  ]);

  home.packages = with pkgs; [
    (unp.override {
      extraBackends = [ unrar ];
    })
    unixtools.netstat
    file
    snicat
    netcat
    qemu
    gcc
    pwndbg
    xxd
    imagemagick
    nmap
    gobuster
    nikto
    metasploit
  ];
}
