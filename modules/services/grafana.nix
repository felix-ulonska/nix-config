{ lib, config, ... }:
with lib;
let
  cfg = config.jabbi.grafana;
in
{
  options.jabbi.grafana = {
    enable = mkEnableOption "Enable ForgeServer";
  };
  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      domain = "grafana.zapfadventure.de";
      port = 2342;
      addr = "127.0.0.1";
    };

    # nginx reverse proxy
    services.nginx.virtualHosts.${config.services.grafana.domain} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
      };
    };

    services.prometheus = {
      enable = true;
      port = 9001;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9002;
        };
      };
      scrapeConfigs = [
        {
          job_name = "chrysalis";
          static_configs = [{
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }];
        }
      ];
    };
    services.loki = {
      enable = true;
      configFile = ../../data/loki-local-config.yaml;
    };
    systemd.services.promtail = {
      description = "Promtail service for Loki";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.grafana-loki}/bin/promtail --config.file ${../../data/promtail.yaml}
        '';
      };
    };
  };
}
