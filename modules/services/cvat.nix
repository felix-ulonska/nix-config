# Config for Computer Vision Annotation Tool (CVAT)
# Config is mainly inspired by their docker-compose
# see https://github.com/openvinotoolkit/cvat/blob/develop/docker-compose.yml
{ pkgs, lib, config, ... }:
with builtins; with lib;
let
  cfg = config.jabbi.services.cvat;
  #backend = config.virtualisation.oci-containers.backend;
  serviceName = "cvat";
  #envFile = config.age.secrets."cvat.env".path;
  backendPort = 50000;
  frontendPort = 50001;
in
{
  options.jabbi.services.cvat = with types; {
    enable = mkEnableOption "Enable Computer Vision Annotation Tool (CVAT)";
    path = mkOption {
      type = types.str;
      default = "/var/lib/cvat";
    };
    domain = mkOption {
      type = types.str;
      default = "my-cvat.webfoo.de";
    };
  };

  config = mkIf cfg.enable {
    systemd.services."create-dockernet-${serviceName}" = {
      script = "docker network create ${serviceName} || true";
      path = [ pkgs.docker ];

      wantedBy = [ "multi-user.target" ];
      after = [ "docker.service" "docker.socket" ];
      before = [ "docker-${serviceName}-db.service" ];
      serviceConfig.Type = "oneshot";
    };

    systemd.services."fix-file-prems-${serviceName}" = {
      script = "chmod 700 -R ${cfg.path}; chown 1000:1000 -R ${cfg.path}";

      wantedBy = [ "multi-user.target" ];
      after = [ "docker.service" "docker.socket" ];
      before = [ "docker-${serviceName}-db.service" ];
      serviceConfig.Type = "oneshot";
    };

    virtualisation.oci-containers.containers = {
      "${serviceName}-db" = {
        image = "postgres:10-alpine";
        extraOptions = [ "--network=${serviceName}" ];
        #environmentFiles = [ envFile ];
        environment = {
          POSTGRES_DB = "cvat";
          POSTGRES_USER = "cvat";
          POSTGRES_PASSWORD = "cvat";
        };
        volumes = [
          "${cfg.path}/db:/var/lib/postgresql/data"
        ];
      };

      "${serviceName}-redis" = {
        image = "library/redis:4.0-alpine";
        extraOptions = [ "--network=${serviceName}" ];
      };

      "${serviceName}-backend" = {
        image = "openvino/cvat_server";
        extraOptions = [ "--network=${serviceName}" ];
        dependsOn = [
          "${serviceName}-db"
          "${serviceName}-redis"
          #"${serviceName}-opa"
        ];
        environment = {
          DJANGO_MODWSGI_EXTRA_ARGS = '''';
          ALLOWED_HOSTS = "*";
          CVAT_REDIS_HOST = "${serviceName}-redis";
          CVAT_POSTGRES_HOST = "${serviceName}-db";
          ADAPTIVE_AUTO_ANNOTATION = "false";
          no_proxy = "elasticsearch,kibana,logstash,nuclio,opa";
          CVAT_POSTGRES_USER = "cvat";
          CVAT_POSTGRES_PASSWORD = "cvat";
        };
        volumes = [
          "${cfg.path}/data:/home/django/data"
          "${cfg.path}/keys:/home/django/keys"
          "${cfg.path}/logs:/home/django/logs"
        ];
        ports = [ "127.0.0.1:${toString backendPort}:8080" ];
      };

      "${serviceName}-ui" = {
        image = "openvino/cvat_ui";
        dependsOn = [ "${serviceName}" ];
        extraOptions = [ "--network=${serviceName}" ];
        ports = [ "127.0.0.1:${toString frontendPort}:80" ];
      };

      #"${serviceName}-opa" = {
      #  image = "openpolicyagent/opa:0.34.2-rootless";
      #  extraOptions = [ "--network=${serviceName}" ];
      #  cmd = [ "run --server --addr :8181 --set=decision_logs.console=true /rules" ];
      #};
    };

    services.nginx.virtualHosts."${cfg.domain}" = {
      forceSSL = true;
      enableACME = true;
      # Backend
      locations = {
        "/git".proxyPass = "http://127.0.0.1:${toString backendPort}";
        "/opencv".proxyPass = "http://127.0.0.1:${toString backendPort}";
        "/static".proxyPass = "http://127.0.0.1:${toString backendPort}";
        "/admin".proxyPass = "http://127.0.0.1:${toString backendPort}";
        "/documentation".proxyPass = "http://127.0.0.1:${toString backendPort}";
        "/django-rq".proxyPass = "http://127.0.0.1:${toString backendPort}";
        "/api".proxyPass = "http://127.0.0.1:${toString backendPort}";
        "/".proxyPass = "http://127.0.0.1:${toString frontendPort}";
      };
    };
  };
}
