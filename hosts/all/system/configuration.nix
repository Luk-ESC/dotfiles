{ config, host, ... }: {
  networking.hostName = host;

  atlas.networkmanager.enable = false;
  services.chrony.enable = true;
  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale.path;
  };

  users.users.eschb = {
    isNormalUser = true;
    uid = 1000;
    hashedPasswordFile = config.age.secrets.linuxpw.path;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  virtualisation =
    let
      options = {
        virtualisation.memorySize = 8192;
        virtualisation.graphics = true;
        virtualisation.cores = 6;
      };
    in
    {
      vmVariant = options;
      vmVariantWithDisko = options;
      docker.rootless = {
        enable = true;
        setSocketVariable = true; # <--- interferes with podman python client `from_env`
        # fix broken dns
        daemon.settings = {
          dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
      };
    };

  # Disable nano
  programs.nano.enable = false;
}
