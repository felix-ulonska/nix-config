let
  jabbi =
    let
      user = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo" ];
      hosts = {
        mino = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINelY0qrdPWByck5+BYZW2y/PO91Jmb2yhaZm1tjYBR2 jabbi@pop-os" ];
        silbervogel = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmLycAW+mP5vSf0va59qTS7bHs509Y6cpXUOTvnNrL/ root@nixos" ];
      };
    in
    {
      computers = user ++ (builtins.foldl' (a: b: a ++ b) [ ] (builtins.attrValues hosts)); # everything
    };
in
{
  inherit jabbi;
}