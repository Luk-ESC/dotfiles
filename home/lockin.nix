{
  copai,
  wallpapers,
  lib,
  ...
}:
{
  specialisation.lockin.configuration = {
    stylix.image = lib.mkForce (wallpapers.outPath + "/default");
    programs.niri.settings.animations.enable = lib.mkForce false;
    services.mako.enable = lib.mkForce false;
    programs.firefox.profiles.default.extensions.packages = [ copai ];
  };
}
