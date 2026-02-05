{ pkgs, pwndbg, ... }:
{
  # Terminal tools
  imports = [
    ./bottom.nix
    ./fastfetch.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./ni.nix
    ./podman.nix
    ./ripgrep.nix
    ./ssh.nix
    ./switchwall.nix
    ./tealdeer.nix
    ./wine.nix
    ./wl-clipboard.nix
    ./zellij.nix
  ];

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
