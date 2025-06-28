{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

   programs.bash = {
     enable = true;
     profileExtra = ''
       # Start hyprland from tty
       if uwsm check may-start; then
           exec uwsm start hyprland-uwsm.desktop
       fi
     '';
   };
}
