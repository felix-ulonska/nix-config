{ lib, config, ... }:
with lib;
let
  cfg = config.jabbi.services.uptime-kuma;
in
{
  options.jabbi.services.uptime-kuma = {
    enable = mkEnableOption "Enable Uptime Kuma";
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      uptime-kuma = {
        image = "louislam/uptime-kuma"
        autostart = true;
        ports = [ "127.0.0.1:3001:3001" ];
        volumes = [ "/var/lib/uptime-kuma:/app/data" ];
      };
    };
    services.nginx.virtualhosts = {
      "uptime.webfoo.de" = {
        forcessl = true;
        enableacme = true;
        locations."/" = {
         proxyPass = "http://127.0.0.1:3001";
         proxyWebsockets = true;
         extraConfig = ''
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         '';
      };
    };
  }
}
