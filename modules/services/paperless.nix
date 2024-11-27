{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.jabbi.services.paperless;
in
{
  options.jabbi.services.paperless = {
    enable = mkEnableOption "Enable Paperless";
  };
  config = mkIf cfg.enable {
    services.paperless-fixed = {
      enable = true;
      port = 9212;
      dataDir = "/var/lib/paperless";
    };

    services.nginx.virtualHosts = {
      "paperless.webfoo.de" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9212";
          proxyWebsockets = true;
        };
      };
    };

    systemd.services."backup-paperless" = {
      serviceConfig.Type = "oneshot";
      startAt = "*-*-* 00:03:00";
      path = [ pkgs.restic ];
      script = "
        mkdir -p backup
        #./var/lib/paperless/paperless-manage backup 
        restic --cache-dir /nix/persist/restic-cache -p /run/agenix/restic-paperless-password -r b2:silberpfeil:/paperless backup /var/lib/paperless
        ";
    };
  };
}
