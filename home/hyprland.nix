{ config, ... }:
{
  persist.caches.contents = [
    ".local/share/hyprland/lastVersion"
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, Q, exec, alacritty"
          "$mod, C, killactive"
          "$mod, E, exec, fuzzel"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
      input = {
        kb_layout = "de";
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        blur = {
          size = 3;
          passes = 1;
        };
      };

      monitor = ",preferred,auto,1";

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
    };
  };

  programs.fuzzel.enable = true;

  home.file."${config.xdg.configHome}/uwsm/env".text = "export QT_QPA_PLATFORM=wayland";

  programs.bash = {
    enable = true;
    profileExtra = ''
      # Start hyprland from tty
      if uwsm check may-start; then
          udevadm settle
          exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };
}
