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
    #age.secrets = {
    # authentik = {
    #  file = ../../secrets/authentik.age;
    #};
    #};
    #services.authentik = {
    # enable = false;
    #disable_startup_analytics = true;
    #environmentFile = "/run/secrets/authentik";
    #nginx = {
    #  enable = true;
    #  enableACME = true;
    #  host = "sso.webfoo.de";
    #};
    #};
  };
}
