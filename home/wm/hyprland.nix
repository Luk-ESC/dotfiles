{
  config,
  lib,
  pkgs,
  ...
}:
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
          "$mod, Q, exec, uwsm app -- alacritty"
          "$mod, C, killactive"
          "$mod, E, exec,  uwsm app -- fuzzel"
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

      binde =
        let
          amixer = lib.getExe' pkgs.alsa-utils "amixer";
          brightnessctl = lib.getExe pkgs.brightnessctl;
          splitColon = lib.splitString ": ";
        in
        (map
          (
            l: ", XF86Audio${builtins.elemAt (splitColon l) 0}, execr, ${amixer} set ${lib.last (splitColon l)}"
          )
          [
            "RaiseVolume: Master 5%+"
            "LowerVolume: Master 5%-"
            "Mute: Master toggle"
            "MicMute: Capture toggle"
          ]
        )
        ++ [
          ", XF86MonBrightnessUp, execr, ${brightnessctl} s 5%+"
          ", XF86MonBrightnessDown, execr, ${brightnessctl} s 5%-"
        ];

      input = {
        kb_layout = "de";
        touchpad.natural_scroll = true;
        repeat_delay = 500;
        repeat_rate = 25;
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

      monitor = ",preferred,auto,1.5";

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

  home.file."${config.xdg.configHome}/uwsm/env".text = ''
    export QT_QPA_PLATFORM=wayland

    # Hint electron apps to use wayland
    export NIXOS_OZONE_WL=1
  '';

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
