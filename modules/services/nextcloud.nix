{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.jabbi.services.nextcloud;
in
{
  options.jabbi.services.nextcloud = {
    enable = mkEnableOption "Enable Nextcloud";
  };
  config = mkIf cfg.enable {
    age.secrets = {
      nextcloud-db-pass = {
        file = ../../secrets/nextcloud-db-pass.age;
        owner = "nextcloud";
        group = "nextcloud";
      };
      nextcloud-admin-pass = {
        file = ../../secrets/nextcloud-admin-pass.age;
        owner = "nextcloud";
        group = "nextcloud";
      };
      restic-nextcloud-password = {
        file = ../../secrets/restic-nextcloud-password.age;
      };
    };

    services.nextcloud = {
      enable = true;
      hostName = "cloud.webfoo.de";
      package = pkgs.nextcloud28;

      # Use HTTPS for links
      https = true;

      # Auto-update Nextcloud Apps
      autoUpdateApps.enable = true;
      # Set what time makes sense for you
      autoUpdateApps.startAt = "05:00:00";

      caching.redis = true;

      config = {
        # Further forces Nextcloud to use HTTPS
        overwriteProtocol = "https";

        # Nextcloud PostegreSQL database configuration, recommended over using SQLite
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
        dbname = "nextcloud";
        dbpassFile = "/run/agenix/nextcloud-db-pass";

        adminpassFile = "/run/agenix/nextcloud-admin-pass";
        adminuser = "admin";
      };
    };

    services.redis = {
      enable = true;
    };

    services.postgresql = {
      enable = true;

      # Ensure the database, user, and permissions always exist
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        {
          name = "nextcloud";
          # Does not work anymore, but hope for the best?!
          #ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
        }
      ];
    };

    systemd.services."nextcloud-setup" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };

    systemd.services."backup-nextcloud" = {
      serviceConfig.Type = "oneshot";
      startAt = "*-*-* 00:03:00";
      path = [ pkgs.restic pkgs.sudo pkgs.curl pkgs.jq ];
      script = "
        export $(grep -v '^#' /run/agenix/resticSecrets | xargs)
        /run/current-system/sw/bin/nextcloud-occ maintenance:mode --on

        sudo -u nextcloud /run/current-system/sw/bin/pg_dump nextcloud -U nextcloud -f /var/lib/nextcloud/nextcloud-sqlbkp_`date +\"%Y%m%d\"`.bak
        restic --cache-dir /nix/persist/restic-cache -p /run/agenix/restic-nextcloud-password -r b2:silberpfeil:/nextcloud backup /var/lib/nextcloud
        rm /var/lib/nextcloud/nextcloud-sqlbkp_*
        curl $(cat /run/agenix/heatlhchecks-url | jq -r '.nextcloud')
        ";
      postStop = "/run/current-system/sw/bin/nextcloud-occ maintenance:mode --off";
    };

    age.secrets = {
      heatlhchecks-url = {
        file = ../../secrets/healthckecksurls.age;
      };
    };

    virtualisation.oci-containers.containers = {
      nextcloud-imaginary = {
        image = "h2non/imaginary";
        autoStart = true;
        ports = [ "127.0.0.1:9000:9000" ];
        environment = {
          PORT = "9000";
        };
      };
    };
  };
}
