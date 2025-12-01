{ pkgs, ... }:
{
  home.packages = [ pkgs.retroarch-free ];

  persist.session.contents = [
    ".config/retroarch/"
  ];
}
