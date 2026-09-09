{ config, ... }:
let
  mkConf = port: {
    extraConfig = ''
      tls ${../../../certificates/lukesc.com.crt} ${config.age.secrets.lukesc_com_key.path}
      reverse_proxy 127.0.0.1:${port}
    '';
  };
in
{
  services.caddy = {
    enable = true;

    virtualHosts."opencode.lukesc.com" = mkConf "4096";
  };

  age.secrets.lukesc_com_key = {
    owner = "caddy";
    group = "caddy";
  };

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 ];
  };
}
