{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*".identityFile = "${config.home.homeDirectory}/nixcfg/keys/id_ed25519";
    };
  };

  persist.data.contents = [
    # TODO: fix permissions
    ".ssh/"
  ];
}
