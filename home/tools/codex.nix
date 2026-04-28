{ pkgs, lib, ... }:
{
  home.shellAliases.codex = "${lib.getExe pkgs.bun} x @openai/codex";

  # TODO: configure .codex/config.toml?
  atlas.codex.enable = true;
}
