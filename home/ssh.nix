{ lib, ... }: {
  home.activation = let
    sshKeyPath = ../keys/id_ed25519;
    sshPubKeyPath = ../keys/id_ed25519.pub;
  in {
    removeExisting = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      rm -rf .ssh/id_ed25519 .ssh/id_ed25519.pub
    '';

    copy = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      rm -rf .ssh/id_ed25519 .ssh/id_ed25519.pub
      cp "${sshKeyPath}" .ssh/id_ed25519
      cp "${sshPubKeyPath}" .ssh/id_ed25519.pub

      chmod 0600 .ssh/id_ed25519
      chmod 0644 .ssh/id_ed25519.pub
    '';
  };

  programs.ssh.enable = true;
}
