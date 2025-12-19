{ config, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings.label = {
      text = "$TIME";
      color = "rgb(${config.lib.stylix.colors.base05})";

      font_size = 120;
      font_family = "Noto Sans";

      position = "0, 25%";
      halign = "center";
      valign = "center";
    };
  };
}
