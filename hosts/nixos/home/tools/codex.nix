{
  config,
  pkgs,
  lib,
  ...
}:
let
  codex-chirp = pkgs.callPackage ../../../../pkgs/codex-chirp.nix { };
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
  hooks-file = pkgs.writeText "codex-hooks.json" (
    builtins.toJSON {
      hooks = {
        PermissionRequest = [ hook ];
        Stop = [ hook ];
      };
    }
  );
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

    context = ''
      # Local environment

      - This machine runs NixOS. Do not assume an FHS-style filesystem or that tools are installed globally.
      - Prefer invoking commands directly. Do not wrap commands in `bash -lc`, `sh -c`, or `zsh -lc` unless shell syntax is genuinely required, and set command tools to non-login mode (for example, `login = false`) when supported. Raw commands allow Codex command-prefix rules to match reliably.
      - When a tool is unavailable, use `n <package> [args...]` to run it from nixpkgs. For example, use `n jq --version`. The `ni` helper runs `NIXPKGS_ALLOW_UNFREE=1 nix run --impure "nixpkgs#<package>" -- [args...]`.
      - This NixOS installation uses persistence/impermanence. Paths below `/persistent` are common, intentional locations for durable data and configuration; account for them when resolving paths and symlinks.
      - Use Podman and `podman-compose` for containers. Do not use Docker or `docker-compose`; translate Docker-oriented instructions to their Podman equivalents.
      - The desktop is Wayland-based and uses the Niri window manager. Prefer Niri- and Wayland-compatible tools and instructions over X11-specific ones.
    '';
  };
}
