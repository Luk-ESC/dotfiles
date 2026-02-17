{ pkgs, ... }:
{
  home.packages = [ pkgs.binaryninja-free ];

  persist.data.contents = [
    ".config/Vector 35/Binary Ninja.conf"
    ".binaryninja/plugins/"
    ".binaryninja/license.dat"
  ];

  persist.session.contents = [
    ".binaryninja/"
  ];
}
