{}: {
  services.nginx = {
     enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

     virtualHosts = {
       "nix.zapfadventure.de" = {
         ## Force HTTP redirect to HTTPS
         forceSSL = true;
         ## LetsEncrypt
         enableACME = true;
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    # Replace the email here!
    defaults.email = "acme@webfoo.de";
  };
}
