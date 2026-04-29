{ pkgs, ... }:
{
  atlas.maven.enable = true;

  programs.helix.extraPackages = [
    pkgs.jdt-language-server
  ];
}
