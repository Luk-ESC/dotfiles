{
  pkgs,
  lib,
  config,
  ...
}:
let
  keep = config.services.keep.package;
in
{
  home.packages = [
    pkgs.xwayland-satellite
  ];

  programs.zsh.profileExtra = ''
    LOCKFILE="$XDG_RUNTIME_DIR/.niri-session.lock"

    if [ ! -f "$LOCKFILE" ]; then
        echo $! > "$LOCKFILE"
        niri-session
    fi
  '';

  programs.niri = {
    package = pkgs.niri;
    settings = {
      spawn-at-startup = [
        { argv = [ (lib.getExe keep) ]; }
      ];

      layer-rules = [
        {
          matches = [ { namespace = "^keep-wallpaper$"; } ];
          place-within-backdrop = true;
        }
      ];

      gestures.hot-corners.enable = false;
      input = {
        keyboard = {
          xkb.layout = "at(nodeadkeys)";
          repeat-delay = 500;
          repeat-rate = 25;
        };

        touchpad = {
          natural-scroll = true;
        };

        mouse.natural-scroll = false;
      };

      outputs.eDP-1 = {
        scale = 1.5;
        mode = {
          width = 2880;
          height = 1800;
        };
      };

      hotkey-overlay.skip-at-startup = true;
      debug.honor-xdg-activation-with-invalid-serial = true;

      binds =
        with config.lib.niri.actions;
        let
          alacritty = lib.getExe pkgs.alacritty;
          pamixer = lib.getExe pkgs.pamixer;
          brightnessctl = lib.getExe pkgs.brightnessctl;
          playerctl = lib.getExe pkgs.playerctl;
          spawnKeep = spawn (lib.getExe keep);
        in
        {
          # Apps
          "Mod+L".action = spawnKeep "lock";
          "Mod+Q".action = spawn alacritty;
          "Mod+B".action = spawn alacritty "-T" "Bunny" "-e" "${../../../../pkgs/bunny}/bunny.sh";
          "Mod+R".action = spawn (lib.getExe pkgs.firefox);
          "Mod+E".action = spawnKeep "launcher";
          "Mod+A".action = spawnKeep "wallpapers";
          "Mod+U".action = spawnKeep "timetable";
          # "Mod+V".action = spawnIpc "launcher clipboard";
          "Mod+C".action = close-window;

          # Audio
          XF86AudioRaiseVolume.action = spawn pamixer "--increase" "5";
          XF86AudioLowerVolume.action = spawn pamixer "--decrease" "5";
          XF86AudioMute.action = spawn pamixer "--toggle-mute";
          XF86AudioMicMute.action = spawn pamixer "--default-source" "--toggle-mute";

          # Brightness
          XF86MonBrightnessUp.action = spawn brightnessctl "set" "+5%";
          XF86MonBrightnessDown.action = spawn brightnessctl "set" "5%-";

          # Media
          XF86AudioPlay.action = spawn playerctl "play-pause";
          XF86AudioNext.action = spawn playerctl "next";
          XF86AudioPrev.action = spawn playerctl "previous";

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

          "Mod+Shift+V".action = toggle-window-floating;

          # Screenshots (FIXME: sodiboo/niri-flake#1380)
          Print.action.screenshot = [ ];
          "Alt+Print".action.screenshot-window = [ ];

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
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+W".action = center-column;
        };

      overview = {
        workspace-shadow.enable = false;
      };

      layout = {
        border.width = 2.0;
        gaps = 10;
        struts = {
          bottom = 3;
          top = 3;
          right = 3;
          left = 3;
        };
        shadow.enable = true;
        background-color = "transparent";
      };

      environment = {
        QT_QPA_PLATFORM = "wayland";
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };

      prefer-no-csd = true;
      window-rules = [
        # FIXME: Remove when alacritty supports ext-background-effect
        {
          matches = [ { app-id = "^Alacritty$"; } ];
          background-effect.blur = true;
        }
        {
          matches = [
            {
              app-id = ".*";
            }
          ];

          clip-to-geometry = true;
          geometry-corner-radius = {
            bottom-left = 10.0;
            bottom-right = 10.0;
            top-left = 10.0;
            top-right = 10.0;
          };
        }
        {
          matches = [ { title = "Bunny"; } ];

          open-maximized = true;
        }
        {
          matches = [
            { app-id = "^firefox$"; }
            { app-id = "^com.vector35.binaryninja$"; }
          ];

          popups = {
            opacity = 0.8;
            geometry-corner-radius = {
              bottom-left = 10.0;
              bottom-right = 10.0;
              top-left = 10.0;
              top-right = 10.0;
            };
            background-effect = {
              blur = true;
              saturation = 3;
            };
          };
        }
        {
          matches = [
            {
              app-id = "^firefox$";
              title = "^Picture-in-Picture$";
            }
          ];

          open-floating = true;
          default-floating-position = {
            relative-to = "bottom-right";
            x = 32;
            y = 32;
          };

          default-column-width.proportion = 0.25;
          default-window-height.proportion = 0.25;
          focus-ring.enable = false;
          border.enable = false;
        }
      ];
    };
  };
}
