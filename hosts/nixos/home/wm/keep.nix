{ config, assets, ... }: {
  services.keep = {
    enable = true;
    systemd.enable = false;

    settings = {
      wallpaper = assets.outPath + "/wallpapers/default";
      wallpaper_change_hook = ../../../../scripts/activate-wallpaper.sh;
      wallpaper_directory = assets.outPath + "/wallpapers/";
      avatar = assets.outPath + "/pfp.png";

      untis.credentials_file = "${config.xdg.userDirs.projects}/nixcfg/keys/untis_creds";
    };
  };
}
