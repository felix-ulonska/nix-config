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
}
