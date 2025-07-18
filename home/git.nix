{config, ...}: {
  programs.git = {
    enable = true;

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
