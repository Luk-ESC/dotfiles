{
  lib,
  assets,
  config,
  ...
}:

let
  idArray = l: builtins.map (x: { id = x; }) l;
  noctalia = config.programs.noctalia-shell.package;
in
{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      settingsVersion = 0;
      bar = {
        barType = "floating";
        density = "comfortable";
        capsuleOpacity = lib.mkForce 0.5;
        enableExclusionZoneInset = true;
        # marginVertical = 4.0;
        marginHorizontal = 10.0;
        outerCorners = true;
        hideOnOverview = false;
        widgets = {
          left = idArray [
            "Launcher"
            "Clock"
            "SystemMonitor"
            "ActiveWindow"
          ];
          center = [
            {
              id = "Workspace";
              focusedColor = "tertiary";
            }
          ];
          right = idArray [
            "MediaMini"
            "Tray"
            "NotificationHistory"
            "Battery"
            "Volume"
            "Brightness"
            "ControlCenter"
          ];
        };
      };
      general = {
        avatarImage = assets.outPath + "/pfp.png";
        showScreenCorners = true;
        forceBlackScreenCorners = true;
        screenRadiusRatio = 0.45;

        # lock screen
        lockScreenAnimations = true;
        lockOnSuspend = true;
        enableLockScreenMediaControls = false;
        showSessionButtonsOnLockScreen = false;
        passwordChars = true;
        lockScreenBlur = 0.1;

        enableShadows = true;
        enableBlurBehind = false;
        showChangelogOnStartup = true;
        telemetryEnabled = false;
      };

      wallpaper = {
        directory = assets.outPath + "/wallpapers";
        showHiddenFiles = false;
        transitionDuration = 2500;
        panelPosition = "center";
        hideWallpaperFilenames = true;
      };

      appLauncher = {
        enableClipboardHistory = false;
        autoPasteClipboard = false;
        enableClipPreview = true;
        clipboardWrapText = true;
        enableClipboardSmartIcons = true;
        enableClipboardChips = true;
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        position = "center";
        pinnedApps = [ ];
        sortByMostUsed = true;
        terminalCommand = "alacritty -e";
        customLaunchPrefixEnabled = false;
        customLaunchPrefix = "";
        viewMode = "list";
        showCategories = true;
        iconMode = "tabler";
        showIconBackground = false;
        enableSettingsSearch = true;
        enableWindowsSearch = true;
        enableSessionSearch = true;
        ignoreMouseInput = false;
        screenshotAnnotationTool = "";
        overviewLayer = false;
        density = "default";
      };

      controlCenter = {
        shortcuts = {
          left = idArray [
            "Network"
            "Bluetooth"
            "WallpaperSelector"
            "NoctaliaPerformance"
          ];
          right = idArray [
            "Notifications"
            "PowerProfile"
            "KeepAwake"
            "NightLight"
          ];
        };
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };

      dock.enabled = false;

      sessionMenu = {
        enableCountdown = false;
      };

      notifications = {
        enabled = true;
        enableMarkdown = false;
        density = "default";
        monitors = [ ];
        location = "top_right";
        overlayLayer = true;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3.0;
        normalUrgencyDuration = 8.0;
        criticalUrgencyDuration = 15;
        clearDismissed = true;
        saveToHistory = {
          low = true;
          normal = true;
          critical = true;
        };
        sounds = {
          enabled = false;
          volume = 0.5;
          separateSounds = false;
          criticalSoundFile = "";
          normalSoundFile = "";
          lowSoundFile = "";
          excludedApps = "discord,firefox,chrome,chromium,edge";
        };
        enableMediaToast = false;
        enableKeyboardLayoutToast = true;
        enableBatteryToast = true;
      };

      osd = {
        enable = true;
        location = "top";
        autoHideMs = 1500;
        enabledTypes = builtins.genList (i: i) 4;
      };

      audio = {
        spectrumFrameRate = 30;
        spectrumMirrored = true;
      };

      colorSchemes = {
        useWallpaperColors = false;
        predefinedScheme = "Noctalia (default)";
        darkMode = true;
      };

      nightLight.enabled = true;

      hooks = {
        enabled = true;
        wallpaperChange = "${../../scripts/activate-wallpaper.sh} $1";
        startup = "noctalia-shell ipc call lockScreen lock";
      };

      # desktopWidgets = {
      #   enabled = false;
      #   overviewEnabled = true;
      #   gridSnap = false;
      #   gridSnapScale = false;
      #   monitorWidgets = [ ];
      # }; TODO: might be cool, idk
    };
  };
}
