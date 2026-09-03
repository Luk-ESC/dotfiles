{ config, ... }: {

  atlas.networkmanager.enable = false;
  services.chrony.enable = true;

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
    };

  # Disable nano
  programs.nano.enable = false;
}
