{ pkgs, ... }:
let
  base = ".maltego/";
  versionPath = "${base}v${pkgs.maltego.version}";
in
{
  home.packages = [ pkgs.maltego ];

  persist.logs.contents = [
    "${versionPath}/var/log/"
  ];

  persist.caches.contents = [
    "${versionPath}/var/cache/"
  ];

  persist.session.contents = [ base ];
}
