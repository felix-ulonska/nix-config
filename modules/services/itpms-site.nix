{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.jabbi.services.itpms-site;
in
{
  options.jabbi.services.itpms-site = {
    enable = mkEnableOption "Enable ITPMS-Site";
  };
  config = mkIf cfg.enable {

    services.nginx.virtualhosts = {
      "it-projekt-muenster.de" = {
        forcessl = true;
        enableacme = true;
        root = "${inputs.itpms-site.defaultpackage.x86_64-linux}/public";
      };
      "old.it-projekt-muenster.de" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/lib/old-itpms";
      };
    };
  };
}
