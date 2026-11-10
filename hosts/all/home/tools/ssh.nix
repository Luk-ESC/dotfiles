{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*".identityFile = "${config.xdg.userDirs.projects}/nixcfg/keys/id_ed25519";
    };
  };
}
