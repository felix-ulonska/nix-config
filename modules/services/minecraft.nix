{ lib, config, ... }:
with lib;
let
  cfg = config.jabbi.services.minecraft;
in
{
  options.jabbi.services.minecraft = {
    enable = mkEnableOption "Enable ForgeServer";
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      minecraft = {
        image = "itzg/minecraft-server";
        autoStart = true;
        ports = [ "25565:25565" ];
        environment = {
          eula = "true";
          type = "forge";
          version = "1.18.1";
          # forgeversion = "39.0.43"
          memory = "10g";
        };
        volumes = [ "/var/lib/minecraft:/data" ];
      };
    };
    systemd.services.minecraft-folder = {
      script = ''
        mkdir -p /var/lib/minecraft
      '';
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
    };

    age.secrets = {
      restic-minecraft-password = {
        file = ../../secrets/restic-minecraft-password.age;
      };
    };

    services.restic.backups = {
      minecraft = {
        repository = "b2:silberpfeil:/minecraft";
        paths = [ "/var/lib/minecraft/" ];
        initialize = true; # initializes the repo, don't set if you want manual control
        environmentFile = "/run/agenix/resticSecrets";
        passwordFile = "/run/agenix/restic-minecraft-password";
        #timerConfig = {
        #onCalendar = "*-*-* *:00:01";
        #};
        timerConfig = {
          onCalendar = "hourly";
        };
      };
    };
  };
}
