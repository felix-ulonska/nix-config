let pubkeys = import ../data/pubkeys.nix; in
{
  "nextcloud-db-pass.age" = {
    publicKeys = pubkeys.jabbi.computers;
    owner = "nextcloud";
    group = "nextcloud";
  };
}
