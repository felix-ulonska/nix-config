{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  nixpkgs.config.allowUnfree = true;

  jabbi.services.gitlab-runner.enable = true;
  jabbi.docker.enable = true;
  jabbi.services.itpms-site.enable = true;

  jabbi.services.nextcloud.enable = true;
  jabbi.services.nginx.enable = true;
  jabbi.services.mail.enable = true;
  jabbi.services.uptime-kuma.enable = true;
  # jabbi.services.fix-ms.enable = true;
  jabbi.services.paperless.enable = true;

  jabbi.services.wordpress.enable = true;

  networking.hostName = "fact-cube";

  time.timeZone = "Europe/Amsterdam";

  users.users.jabbi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcA1n51lr45ap7lQ729I3RpReyo0xGEASZpf63ydxWg root@edgeless-safety-cube"
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

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib/minecraft"
      "/var/lib/nextcloud"
      "/var/lib/postgresql"
      "/var/lib/acme"
      "/var/lib/dkim"
      "/var/lib/jmusicbot"
      "/var/lib/uptime-kuma"
      "/var/lib/old-itpms"
      "/var/lib/fixms-frontend"
      "/var/lib/docker"
      "/var/lib/wordpress"
      "/var/lib/paperless"
      "/var/lib/mysql"
      "/var/lib/cvat"
      "/var/vmail"
      "/var/lib/files"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  system.stateVersion = "21.11";

  nix.sshServe.enable = true;
  nix.sshServe.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo" ];
  nix.sshServe.protocol = "ssh-ng";
}
