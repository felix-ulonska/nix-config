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
    services.paperless = {
      enable = true;
      port = 9212;
    };

    services.nginx.virtualHosts = {
      "paperless.webfoo.de" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9212";
        };
      };
    };

    #services.restic.backups = {
    #  mail = {
    #    repository = "b2:silberpfeil:/paperless";
    #    paths = [ "/var/dkim" "/var/paperless" ];
    #    initialize = true; # initializes the repo, don't set if you want manual control
    #    environmentFile = "/run/agenix/resticSecrets";
    #    passwordFile = "/run/agenix/restic-mail-password";
    #    #timerConfig = {
    #    #onCalendar = "*-*-* *:00:01";
    #    #};
    #    timerConfig = {
    #      onCalendar = "hourly";
    #    };
    #  };
    #};
  };
}
