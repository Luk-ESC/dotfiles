{ lib, ... }: {
  home.activation = {
    removeExisting = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      rm -rf .ssh/id_ed25519 .ssh/id_ed25519.pub
    '';

    copy = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      rm -rf .ssh/id_ed25519 .ssh/id_ed25519.pub
      cp nixcfg/keys/id_ed25519 .ssh/
      cp nixcfg/keys/id_ed25519.pub .ssh/

      chmod 0600 .ssh/id_ed25519
      chmod 0644 .ssh/id_ed25519.pub
    '';
  };

  programs.ssh.enable = true;
}
