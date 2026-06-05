{ pkgs, lib, ... }:
{
  home.shellAliases.codex = "${lib.getExe pkgs.bun} x @openai/codex";
  programs.codex = {
    enable = true;
    package = null;
  };
}
