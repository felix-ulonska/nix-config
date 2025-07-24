{ config, pkgs, modulesPath, ... }:
{
  imports =
    [
      ./disk-config.nix
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  nixpkgs.config.allowUnfree = true;

  #jabbi.services.gitlab-runner.enable = true;
  jabbi.docker.enable = true;
  jabbi.services.itpms-site.enable = true;

  jabbi.services.nextcloud.enable = true;
  jabbi.services.nginx.enable = true;
  jabbi.services.mail.enable = true;
  jabbi.services.uptime-kuma.enable = true;
  jabbi.services.rustdesk.enable = true;
  ## jabbi.services.fix-ms.enable = true;
  jabbi.services.paperless.enable = true;
  jabbi.services.wordpress.enable = true;

  networking.hostName = "edgeless-safety-cube";

  time.timeZone = "Europe/Amsterdam";
  #networking.interfaces.ens3.ipv6.addresses = [{
  #  address = "2a0a:4cc0:0:230a::";
  #  prefixLength = 64;
  #}];

  users.users.jabbi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    restic
    htop
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 25565 ];

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  system.stateVersion = "21.11";

  nix.sshServe.enable = true;
  nix.sshServe.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo" ];
  nix.sshServe.protocol = "ssh-ng";
}
