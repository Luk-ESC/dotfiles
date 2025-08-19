{ extensions, ... }:
{
  persist.session.contents = [
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
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;

      ExtensionSettings = {
        "*".installation_mode = "force_installed";
      };
    };

    profiles.default = {
      #bookmarks.force = true;
      containersForce = true;
      extensions = {
        force = true;
        packages = with extensions; [
          ublock-origin
          firefox-color
          tree-style-tab
          darkreader
        ];
      };
      search.force = true;
    };
  };

  stylix.targets.firefox = {
    profileNames = [ "default" ];
    colorTheme.enable = true;
  };
}
