{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [
    pkgs.xwayland-satellite
  ];

  programs.fuzzel.enable = true;

  programs.niri = {
    package = pkgs.niri;
    settings = {
      input = {
        keyboard = {
          xkb.layout = "at(nodeadkeys)";
          repeat-delay = 500;
          repeat-rate = 25;
        };

        touchpad = {
          natural-scroll = true;
        };

        mouse.natural-scroll = true;
      };

      outputs.eDP-1 = {
        scale = 1.5;
        mode = {
          width = 2880;
          height = 1800;
        };
      };

      binds =
        with config.lib.niri.actions;
        let
          wpctl = lib.getExe' pkgs.wireplumber "wpctl";
          brightnessctl = lib.getExe pkgs.brightnessctl;
        in
        {
          # Apps
          "Mod+Q".action = spawn (lib.getExe pkgs.alacritty);
          "Mod+E".action = spawn (lib.getExe pkgs.fuzzel);
          "Mod+C".action = close-window;

          # Audio
          XF86AudioRaiseVolume.action = spawn wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
          XF86AudioLowerVolume.action = spawn wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
          XF86AudioMute.action = spawn wpctl "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
          XF86AudioMicMute.action = spawn wpctl "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";

          # Brightness
          XF86MonBrightnessUp.action = spawn brightnessctl "s" "5%+";
          XF86MonBrightnessDown.action = spawn brightnessctl "s" "5%-";

          # Movement
          "Mod+Left".action = focus-column-left;
          "Mod+Down".action = focus-window-down;
          "Mod+Up".action = focus-window-up;
          "Mod+Right".action = focus-column-right;

          "Mod+Ctrl+Left".action = move-column-left;
          "Mod+Ctrl+Down".action = move-window-down;
          "Mod+Ctrl+Up".action = move-window-up;
          "Mod+Ctrl+Right".action = move-column-right;

          "Mod+Page_Down".action = focus-workspace-down;
          "Mod+Page_Up".action = focus-workspace-up;

          "Mod+Shift+Page_Down".action = move-window-to-workspace-down;
          "Mod+Shift+Page_Up".action = move-window-to-workspace-up;

          # Resize windows
          "Mod+Shift+Left".action = set-column-width "-5%";
          "Mod+Shift+Right".action = set-column-width "+5%";

          "Mod+V".action = toggle-window-floating;

          # Screenshots
          Print.action = screenshot;
          "Alt+Print".action = screenshot-window;

          # Workspaces
          "Mod+1".action = focus-workspace 1;
          "Mod+2".action = focus-workspace 2;
          "Mod+3".action = focus-workspace 3;
          "Mod+4".action = focus-workspace 4;
          "Mod+5".action = focus-workspace 5;
          "Mod+6".action = focus-workspace 6;
          "Mod+7".action = focus-workspace 7;
          "Mod+8".action = focus-workspace 8;
          "Mod+9".action = focus-workspace 9;

          "Mod+O".action = toggle-overview;
          "Mod+F".action = maximize-column;
          "Mod+W".action = center-column;
        };

      layout = {
        border.enable = false;
        shadow.enable = true;
      };

      environment = {
        QT_QPA_PLATFORM = "wayland";
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
