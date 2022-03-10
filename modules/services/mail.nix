{ ... }: {
  age.secrets = {
    mail-password = {
      file = ../../secrets/mail-password.age;
    };
  };
  mailserver = {
    enable = true;
    fqdn = "mail.zapfadventure.de";
    domains = [ "zapfadventure.de" ];

    # A list of all login accounts. To create the password hashes, use
    # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    loginAccounts = {
      "jabbi@zapfadventure.de" = {
        hashedPasswordFile = "/run/agenix/mail-password";
        aliases = [ "postmaster@example.com" ];
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;
  };
}
