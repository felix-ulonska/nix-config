let
  jabbi =
    let
      user = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo" ];
      hosts = {
        mino = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINelY0qrdPWByck5+BYZW2y/PO91Jmb2yhaZm1tjYBR2 jabbi@pop-os" ];
        silbervogel = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHc8FXgqCpSJaBzKk2cQCNOV0hJZG+k/r6DUJCjsCJff root@nixos" ];
        wheatly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHB5A0uxsv9oK04UpKCscoEV6zn1cQVm//boA/DGTtmq root@wheatly" ];
        fact-cube = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDf3XjI1FyC0ax8lffi9xcR8M4kye6rPeRDSroihme97 root@fact-cube" ];
      };
    in
    {
      computers = user ++ (builtins.foldl' (a: b: a ++ b) [ ] (builtins.attrValues hosts)); # everything
    };
in
{
  inherit jabbi;
}
