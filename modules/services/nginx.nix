{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.jabbi.services.nginx;
in
{
  options.jabbi.services.nginx = {
    enable = mkEnableOption "Enable Nginx";
  };
  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      virtualHosts = {
        "cloud.zapfadventure.de" = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@webfoo.de";
    };
  };
}
