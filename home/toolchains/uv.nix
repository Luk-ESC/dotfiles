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

  programs.zed-editor = {
    extensions = [ "ruff" ];
    userSettings = {
      languages.Python.language_servers = [
        "pyright"
        "ruff"
      ];

      lsp = {
        ruff.binary = {
          path = lib.getExe pkgs.ruff;

          arguments = [
            "server"
            "--preview"
          ];
        };

        pyright.binary = {
          path = lib.getExe' pkgs.pyright "pyright-langserver";
          arguments = [ "--stdio" ];
        };
      };
    };
  };
}
