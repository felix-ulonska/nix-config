let pubkeys = import ../data/pubkeys.nix; in
{
  "nextcloud-db-pass.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };

  "nextcloud-admin-pass.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };

  "resticSecrets.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };

  "restic-nextcloud-password.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };

  "restic-minecraft-password.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };

  "mail-password.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };

  "mail-felix-password.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };

  "restic-mail-password.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };

  "gitlab-runner.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };
  
  "cache-priv-key.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };

  "cache-pub-key.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };
}
