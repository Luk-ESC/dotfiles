{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*".identityFile = "${config.home.homeDirectory}/nixcfg/keys/id_ed25519";
    };
  };
}
