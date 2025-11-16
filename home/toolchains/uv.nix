{
  pkgs,
  lib,
  config,
  ...
}:
let
  python = pkgs.python3.withPackages (
    p: with p; [
      pwntools
      requests
      angr
      flask
      z3-solver
      numpy
      opencv-python
      tqdm
      pillow
      matplotlib

      (callPackage ../../pkgs/libdebug.nix { })
    ]
  );
in
{
  home.packages = [ python ];
  home.shellAliases.py = lib.getExe python;

  programs.uv.enable = true;
  programs.ruff = {
    enable = true;
    settings.cache-dir = config.xdg.cacheHome + "/ruff";
  };

  programs.helix.extraPackages = [
    pkgs.ruff
    pkgs.pyright
  ];
}
