{ pkgs, ... }:
{
  programs.go = {
    enable = true;
    telemetry.mode = "off";
  };

  programs.helix.extraPackages = [ pkgs.gopls ];
}
