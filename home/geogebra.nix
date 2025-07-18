{ pkgs, ... }:
{
  persist.data.contents = [
    ".pki/"
    ".config/GeoGebra/"
  ];
  home.packages = [ pkgs.geogebra6 ];
}
