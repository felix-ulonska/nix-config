{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.jabbi.services.keycloak;
in
{
  options.jabbi.services.keycloak = {
    enable = mkEnableOption "Enable Keycloak";
  };
  config = mkIf cfg.enable {
    services.keycloak = {
      enable = true;

      database = {
        type = "postgresql";
        createLocally = true;

        username = "keycloak";
        passwordFile = "/etc/nixos/secrets/keycloak_psql_pass";
      };

      plugins = with pkgs; [
        junixsocket-common
        junixsocket-native-common
      ];

      settings = {
        hostname = "sso.webfoo.de";
      };
    };
  };
}
