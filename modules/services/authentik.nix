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
    sops.secrets."authentik/authentik-env" = { };

    services.authentik = {
      enable = true;
      environmentFile = "/run/secrets/authentik/authentik-env";
      # other authentik options as in the example configuration at the top
      nginx = {
        enable = true;
        enableACME = true;
        host = "auth.tower.webfoo.de";
      };
    };
    services.nginx.enable = true;
  };
}
