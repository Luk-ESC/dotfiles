{ pkgs, lib, ... }: {
  programs.git = {
    enable = true;

    userName = "Luk-ESC";
    userEmail = "eschbacher.lukas@gmail.com";
    signing.signByDefault = true;

    includes = [{
      contents = {
        user = {
          name = "Luk-ESC";
          email = "eschbacher.lukas@gmail.com";
          signingKey = "D0C8FD2AB19DAAE6E658C40E780881B3A960B391";
        };
        commit.gpgSign = true;
      };
    }];
  };

  programs.gpg = {
    enable = true;
    mutableTrust = false;
    mutableKeys = false;
    publicKeys = [{
      source = ../keys/publickey.asc;
      trust = 5;
    }];
  };

  home.activation.importGpgKey = let privateKeyFile = ../keys/secretkeys.asc;
  in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f "${privateKeyFile}" ]; then
      echo "Importing GPG private keys..."
      ${lib.getExe pkgs.gnupg} --batch --import "${privateKeyFile}"
      # Optionally, trust the keys automatically:
      # echo -e "5\ny\n" | gpg --command-fd 0 --edit-key YOUR_KEY_ID trust
    else
      echo "No private key file found at ${privateKeyFile}, skipping import."
    fi
  '';

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
  };
}
