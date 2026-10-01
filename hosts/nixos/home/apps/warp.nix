{ pkgs, ... }:
{
  home.packages = [
    pkgs.warp
  ];

  # supress hello message
  xdg.configFile."warp/config.json".text = builtins.toJSON {
    window = {
      width = 460;
      height = 600;
    };
    welcome_window_shown = true;
    rendezvous_server_url = null;
    transit_server_url = null;
    code_length = null;
  };
}
