{ pkgs, ... }:
{
  home.packages = [ pkgs.binaryninja-free ];
  nixpkgs.config.allowUnfree = true;

  persist.data.contents = [
    ".config/Vector 35/Binary Ninja.conf"
    ".binaryninja/"
  ];
}
