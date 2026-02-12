{ pkgs, ... }:
{
  imports = [
    ./hard-configuration.nix
    ./disk-config.nix
  ];

  users.mutableUsers = false;
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  boot.loader.grub.enable = true;
  services.openssh.enable = true;

  services.postgresql = {
    enable = false;
  };

  system.stateVersion = "25.11";
}
