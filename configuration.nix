{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  jabbi.nginx.enable = true;

  networking.hostName = "nixos";

  time.timeZone = "Europe/Amsterdam";

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  users.users.jabbi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
  ];

  environment.systemPackages = with pkgs; [
    vim
    curl
    sudo
    wget
  ];

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ 22 ];

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  system.stateVersion = "21.11";
}
