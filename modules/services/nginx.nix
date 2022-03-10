{ pkgs, ... }: {
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    virtualHosts = { };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@webfoo.de";
  };
}
