{ pkgs, ... }:
{
  home.packages = [ pkgs.steam ];

  persist.logs.contents = [
    ".local/share/Steam/logs/"
  ];

  persist.caches.contents = [
    ".local/share/Steam/appcache/"
    ".local/share/Steam/steamapps/shadercache/"
  ];

  persist.session.contents = [
    ".local/share/Steam/"
    ".steam/"
  ];
}
