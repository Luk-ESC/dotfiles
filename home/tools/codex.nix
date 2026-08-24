{
  config,
  pkgs,
  lib,
  ...
}:
let
  codex-chirp = pkgs.callPackage ../../pkgs/codex-chirp.nix { };
  codex-home = config.home.sessionVariables.CODEX_HOME;
  hook = {
    hooks = [
      {
        type = "command";
        command = lib.getExe codex-chirp;
        timeout = 3;
      }
    ];
  };
  hooks-file = pkgs.writeText "codex-hooks.json" (builtins.toJSON {
    hooks = {
      PermissionRequest = [ hook ];
      Stop = [ hook ];
    };
  });
in
{
  home.shellAliases.codex = "${lib.getExe pkgs.bun} x @openai/codex@latest";

  home.activation.codex-hooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ${codex-home}
    $DRY_RUN_CMD ln -sfn ${hooks-file} ${codex-home}/hooks.json
  '';

  programs.codex = {
    enable = true;
    package = null;
  };
}
