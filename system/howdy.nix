{ minimal, pkgs, ... }:
{
  services.howdy = {
    enable = !minimal;
    control = "sufficient";

    package = pkgs.howdy.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "Luk-ESC";
        repo = "howdy";
        rev = "fd9f11b2a051783b0f843ee35fc239ab0b6aade5";
        hash = "sha256-5jFPMpL6oYp+opLAHDmyf2lsTVdvK0oviakD9gFYiNY=";
      };
    };

    # The HP Wide Vision camera exposes its IR stream on video2.
    settings.video = {
      device_path = "/dev/video2";

      # This camera only keeps its IR emitter active while the RGB stream is
      # also open. The patched recorder opens it only during authentication.
      companion_device_path = "/dev/video0";
    };
  };

  # Disable howdy for Noctalia.
  security.pam.services.login.howdy.enable = false;
}
