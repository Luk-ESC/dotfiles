{
  persist.session.contents = [
    ".config/vesktop/"
  ];

  programs.vesktop = {
    enable = true;
    settings = {
      discordBranch = "stable";
      arRPC = true;
      minimizeToTray = false;
      checkUpdates = false;
    };

    vencord.settings = {
      autoUpdate = false;
      autoUpdateNotification = false;
      notifyAboutUpdates = false;
      plugins = {
        UserMessagesPronouns.enabled = true;
        CopyFileContents.enabled = true;
        AlwaysTrust.enable = true;
        BetterGifPicker.enable = true;
        ClearURLs.enable = true;
        CustomIdle.idleTimeout = 0;

        ShikiCodeblocks.enable = true;
        MessageClickActions = {
          enabled = true;
          requireModifier = true;
        };
      };
    };
  };
}
