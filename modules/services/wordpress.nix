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
    services.wordpress.sites."it-projekt-muenster.de" = {
      extraConfig = ''
        @ini_set( 'upload_max_size' , '64M' );
        @ini_set( 'post_max_size', '64M');
        @ini_set( 'max_execution_time', '300' );
      '';
      settings = {
        WP_SITEURL = "https://it-projekt-muenster.de";
        WP_HOME = "https://it-projekt-muenster.de";
      };
    };
    services.phpfpm.phpOptions = ''
      upload_max_filesize = 64M
      post_max_size = 128M
      memory_limit = 264M
    '';
    services.nginx.virtualHosts."it-projekt-muenster.de" = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        client_max_body_size 100M;
      '';
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
