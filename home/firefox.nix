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
      bookmarks = {
        force = true;
        settings = [
          {
            name = "wikipedia";
            tags = [ "wiki" ];
            keyword = "+wiki";
            url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
          }
          {
            name = "nixpkgs";
            tags = [
              "nixpkgs"
              "package"
            ];
            keyword = "+np";
            url = "https://search.nixos.org/packages?channel=25.05&query=%s";
          }
          {
            name = "nixos options";
            tags = [
              "nixos"
              "options"
            ];
            keyword = "+no";
            url = "https://search.nixos.org/options?channel=25.05&query=%s";
          }
          {
            name = "youtube";
            tags = [ "youtube" ];
            keyword = "+yt";
            url = "https://www.youtube.com/results?search_query=%s";
          }
        ];
      };

      containersForce = true;
      extensions = {
        force = true;
        packages = with extensions; [
          ublock-origin
          firefox-color
          tree-style-tab
          darkreader
          bitwarden
          sponsorblock
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
