{ pkgs, ... }:
{
  home.packages = [ pkgs.dbeaver-bin ];

  persist.data.contents = [
    ".local/share/DBeaverData/"
  ];

  persist.session.contents = [
    ".local/share/DBeaverData/drivers/"
  ];

  persist.caches.contents = [
    ".eclipse/"
  ];
}
