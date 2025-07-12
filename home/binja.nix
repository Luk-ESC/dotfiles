{ pkgs, ... }: {
  home.packages = [ pkgs.binaryninja-free ];
  nixpkgs.config.allowUnfree = true;
}
