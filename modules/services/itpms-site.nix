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

    services.nginx.virtualHosts = {
      "it-projekt-muenster.de" = {
        forceSSL = true;
        enableACME = true;
        root = "${inputs.itpms-site.defaultPackage.x86_64-linux}/public";
      };
    };
  };
}
