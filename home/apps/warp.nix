{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.warp
  ];

  # supress hello message
  home.file."${config.xdg.configHome}/warp/config.json".text = builtins.toJSON {
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
