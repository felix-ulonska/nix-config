{ lib, config, ... }:
with lib;
let
  cfg = config.jabbi.services.mail;
in
{
  options.jabbi.services.mail = {
    enable = mkEnableOption "Enable ForgeServer";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      mail-password = {
        file = ../../secrets/mail-password.age;
      };
    };
    mailserver = {
      enable = true;
      fqdn = "mail.webfoo.de";
      domains = [ "webfoo.de" ];

      # A list of all login accounts. To create the password hashes, use
      # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
      loginAccounts = {
        "felix@webfoo.de" = {
          hashedPasswordFile = "/run/agenix/mail-felix-password";
          aliases = [ "felix@webfoo.de" ];
        };
      };

      # Use Let's Encrypt certificates. Note that this needs to set up a stripped
      # down nginx and opens port 80.
      certificateScheme = 3;
    };
    services.restic.backups = {
      mail = {
        repository = "b2:silberpfeil:/mail";
        paths = [ "/var/dkim" "/var/vmail" ];
        initialize = true; # initializes the repo, don't set if you want manual control
        environmentFile = "/run/agenix/resticSecrets";
        passwordFile = "/run/agenix/restic-mail-password";
        #timerConfig = {
        #onCalendar = "*-*-* *:00:01";
        #};
        timerConfig = {
          onCalendar = "hourly";
        };
      };
    };
  };
}
