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

  sops.defaultSopsFile = ../../sops-secrets/authentik.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "le@webfoo.de";

  jabbi.services.authentik.enable = true;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  system.stateVersion = "25.11";
}
