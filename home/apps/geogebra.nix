{ pkgs, ... }:
{
  persist.session.contents = [
    ".pki/"
    ".config/GeoGebra/"
  ];
  home.packages = [ pkgs.geogebra6 ];
}
