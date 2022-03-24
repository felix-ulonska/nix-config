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
    publicKeys = pubkeys.jabbi.computers ++ [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHB5A0uxsv9oK04UpKCscoEV6zn1cQVm//boA/DGTtmq root@wheatly" ];
  };

  "mail-password.age" = {
    publicKeys = pubkeys.jabbi.computers;
  };
}
