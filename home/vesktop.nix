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
        MessageClickActions.enabled = true;
        CopyFileContents.enabled = true;
      };
    };
  };
}
