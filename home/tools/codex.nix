{ pkgs, lib, ... }:
{
  home.shellAliases.codex = "${lib.getExe pkgs.bun} x @openai/codex";

  # TODO: configure .codex/config.toml?
  persist.session.contents = [
    ".codex/"
  ];

  persist.caches.contents = [
    ".codex/cache/"
  ];

  persist.logs.contents = [
    ".codex/log/"
  ];
}
