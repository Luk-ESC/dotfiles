{ config, ... }:
{
  programs.git = {
    enable = true;

    aliases = {
      d = "diff";
      cm = "commit -m";
      p = "push";
      dc = "diff --cached";
      s = "status";
      l = "log";
    };

    userName = "Luk-ESC";
    userEmail = "eschbacher.lukas@gmail.com";
    signing = {
      signByDefault = true;
      key = "${config.home.homeDirectory}/nixcfg/keys/id_ed25519.pub";
      format = "ssh";
    };

    extraConfig.init.defaultBranch = "main";
  };
}
