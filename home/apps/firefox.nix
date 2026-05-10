{ extensions, lib, ... }:
{
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
        settings =
          let
            search = d: "${d}?channel=${lib.trivial.release}&query=%s";
            bookmarks = lib.mapAttrsToList (
              k: u: {
                keyword = k;
                url = "https://" + u;
              }
            );
          in
          bookmarks {
            "+wiki" = "en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
            "+np" = search "search.nixos.org/packages";
            "+no" = search "search.nixos.org/options";
            "+nw" = "wiki.nixos.org/w/index.php?search=%s";
            "+ho" = search "home-manager-options.extranix.com";
            "+yt" = "www.youtube.com/results?search_query=%s";
          };
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
          leechblock-ng
          (youtube-recommended-videos.overrideAttrs {
            # HACK: for some reason, this extension can't be added if it has an unfree license.
            meta.license = bitwarden.meta.license;
          })
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
