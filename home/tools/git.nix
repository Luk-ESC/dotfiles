{
  config,
  pkgs,
  lib,
  ...
}:
let
  delta = lib.getExe pkgs.delta;
  delta-auto = lib.getExe (
    pkgs.writeShellScriptBin "delta-auto" ''
      if [ "$(tput cols)" -ge 140 ]; then
          exec ${delta} --side-by-side "$@"
      else
          exec ${delta} "$@"
      fi
    ''
  );
in
{
  programs.git = {
    enable = true;

    signing = {
      signByDefault = true;
      key = "${config.xdg.userDirs.projects}/nixcfg/keys/id_ed25519.pub";
      format = "ssh";
    };

    settings = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      user.name = "Luk-ESC";
      user.email = "eschbacher.lukas@gmail.com";

      alias = {
        d = "diff";
        cm = "commit -m";
        p = "push";
        dc = "diff --cached";
        s = "status";
        l = "log";
        a = "add";
        rbi = "rebase -i";
      };

      # Delta config
      core.pager = delta-auto;
      interactive.diffFilter = "${delta} --color-only";

      delta = {
        line-numbers = true;
        navigate = true;
        hunk-header-style = "omit";
      };
    };
  };
}
