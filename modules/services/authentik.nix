{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.jabbi.services.authentik;
in
{
  options.jabbi.services.authentik = {
    enable = mkEnableOption "Enable authentik";
  };
  config = mkIf cfg.enable {
    age.secrets = {
      authentik = {
        file = ../../secrets/authentik.age;
      };
    };
    services.authentik = {
      enable = true;
      disable_startup_analytics = true;
      avatars = "initials";
      environmentFile = "/run/secrets/authentik";
      nginx = {
        enable = true;
        enableACME = true;
        host = "sso.webfoo.de";
      };
    };
  };
}
