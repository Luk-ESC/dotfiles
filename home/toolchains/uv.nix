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
}
