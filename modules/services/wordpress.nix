{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.jabbi.services.wordpress;
in
{
  options.jabbi.services.wordpress = {
    enable = mkEnableOption "Enable Wordpress";
  };
  config = mkIf cfg.enable {
    services.wordpress.webserver = "nginx";
    services.wordpress.sites."wordpress.it-projekt-muenster.de" = { };
    services.nginx.virtualHosts."wordpress.it-projekt-muenster.de" = {
      forceSSL = true;
      enableACME = true;
    };
    services.restic.backups.wordpress = {
      repository = "b2:silberpfeil:/wordpress";
      paths = [ "/var/lib/wordpress/" "/var/lib/mysql" ];
      initialize = true;
      environmentFile = "/run/agenix/resticSecrets";
      passwordFile = "/run/agenix/restic-wordpress-password";
      backupPrepareCommand = ''
        ${pkgs.mysql}/bin/mysqldump --all-databases > /var/lib/wordpress/backup.sql
      '';
      timerConfig = {
        onCalendar = "hourly";
      };
    };
    age.secrets = {
      restic-wordpress-password = {
        file = ../../secrets/restic-wordpress-password.age;
      };
    };
  };
}
