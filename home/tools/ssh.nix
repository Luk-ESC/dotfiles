{ config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*".identityFile = "${config.home.homeDirectory}/nixcfg/keys/id_ed25519";
    };
  };

  persist.data.contents = [
    # TODO: fix permissions
    ".ssh/"
  ];
}
