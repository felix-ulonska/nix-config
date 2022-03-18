{ config, pkgs, nixpkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  jabbi.home.enable = true;
  jabbi.i3wm.enable = true;

  networking.hostName = "GLaDOS";

  time.timeZone = "Europe/Amsterdam";

  users.users.jabbi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$rejDSpuy6d$za9N7miMI/XHZNjZ6ib0IcaF511UdBn7QVwIV7MO1MTMO5yjVGwuvVT7kJlnTN165srbPd6rCJxtgdABTuEbj1";
  };

  users.mutableUsers = false;
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  system.stateVersion = "21.11";
}
