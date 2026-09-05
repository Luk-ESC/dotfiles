{ config, ... }: {
  services.inadyn = {
    enable = true;
    interval = "*:0/5";
    settings = {
      allow-ipv6 = false;

      provider."default@namecheap.com" = {
        username = "lukesc.com";

        hostname = [
          "ssh"
        ];

        iface = config.services.tailscale.interfaceName;
        include = config.age.secrets.dyndns.path;
      };
    };
  };

  age.secrets.dyndns = {
    owner = "inadyn";
    group = "inadyn";
  };

  systemd.services.inadyn = {
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
  };
}
