{ lib, config, inputs, pkgs, ... }:
with lib;
let
  cfg = config.jabbi.services.fix-ms;
in
{
  options.jabbi.services.fix-ms = {
    enable = mkEnableOption "Enable Fix MS";
  };
  config = mkIf cfg.enable {
    systemd.services."fixms" = {
      path = [
       inputs.fix-ms-backend.defaultPackage.x86_64-linux 
       pkgs.nodejs-16_x
      ];
      script = "rm -rf /tmp/foo ; cp -r ${inputs.fix-ms-backend.defaultPackage.x86_64-linux} /tmp/foo; cd /tmp/foo/; npm i; node src/server.js";
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services."fixms-frontend" = {
      path = [
       inputs.fix-ms-frontend
       pkgs.docker
      ];
      script = ''
        rm -rf /tmp/fixms-frontend/*;
        mkdir -p /tmp/fixms-frontend
        cp -rf ${inputs.fix-ms-frontend}/* /tmp/fixms-frontend 
        cd /tmp/fixms-frontend
        rm -rf /var/lib/fixms-frontend/*;
        mkdir -p /var/lib/fixms-frontend;
        docker rm temp-container-name || :
        echo Started Container
        docker run --name temp-container-name  $(docker build -q .) /bin/true
        echo copying 
        docker cp temp-container-name:/app/build/web /var/lib/fixms-frontend
        docker rm temp-container-name
      '';
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services."fix-ms-prasentation" = {
      path = [
       inputs.fix-ms-prasentation
       pkgs.nodejs-16_x
      ];
      script = ''
        rm -rf /var/lib/fixms-prasentation/*;
        mkdir -p /var/lib/fixms-prasentation/prasentation;
        cp -rf ${inputs.fix-ms-prasentation}/* /var/lib/fixms-prasentation/prasentation
        cd /var/lib/fixms-prasentation/prasentation
        npm i
        npm run build
      '';
      wantedBy = [ "multi-user.target" ];
    };

    services.nginx.virtualHosts = {
      "fixms.webfoo.de" = {
        forceSSL = true;
        enableACME = true;
        locations."/api" = {
          proxyPass = "http://127.0.0.1:9025";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        locations."/prasentation" = {
          root = "/var/lib/fixms-prasentation";
        };
        locations."/" = {
          root = "/var/lib/fixms-frontend/web";
        };
      };
    };
  };
}
