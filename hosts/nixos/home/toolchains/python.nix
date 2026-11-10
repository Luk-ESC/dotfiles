{
  pkgs,
  lib,
  config,
  ...
}:
let
  realPython = pkgs.python3.override {
    packageOverrides =
      python-self: python-super: import ../../../../pkgs/angr.nix pkgs python-self python-super;
  };
  python = realPython.withPackages (
    p: with p; [
      pwntools
      requests
      # FIXME(nixos/nixpkgs #501379): doesn't build on 26.05
      angr
      flask
      z3-solver
      numpy
      opencv-python
      tqdm
      pillow
      matplotlib
      pycryptodomex
      fpylll
      trimesh
      jupyter

      (callPackage ../../../../pkgs/libdebug.nix { })
    ]
  );
in
{
  home.packages = [ python ];
  atlas.python.enable = true;

  home.shellAliases = rec {
    py = lib.getExe python;
    mkvenv = "${lib.getExe pkgs.uv} venv -p ${py}";
    actvenv = "source .venv/bin/activate";
  };

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
