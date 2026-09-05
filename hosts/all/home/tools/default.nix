{
  minimal,
  lib,
  pkgs,
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
    ./tealdeer.nix
    ./zellij.nix
  ]
  ++ (lib.optionals (!minimal) [
    ./podman.nix
  ]);

  home.packages = with pkgs; [
    (unp.override {
      extraBackends = [ unrar ];
    })
    unixtools.netstat
    file
    netcat
  ];
}
