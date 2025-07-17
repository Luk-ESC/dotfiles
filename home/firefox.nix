{ ... }: {
  persist.data.contents = [
    ".mozilla/"
  ];

  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "always";

      #ExtensionSettings = { "*".installation_mode = "blocked"; };
    };

    profiles.default = {
      #bookmarks.force = true;
      containersForce = true;
      extensions.force = true;
      search.force = true;
    };
  };

  stylix.targets.firefox = {
    profileNames = [ "default" ];
    colorTheme.enable = true;
  };
}
