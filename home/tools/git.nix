{ config, ... }:
{
  programs.git = {
    enable = true;

    signing = {
      signByDefault = true;
      key = "${config.home.homeDirectory}/nixcfg/keys/id_ed25519.pub";
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
      };
    };
  };
}
