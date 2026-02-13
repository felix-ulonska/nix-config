{
  config,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./disk-config.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.config.allowUnfree = true;

  sops.defaultSopsFile = ../../sops-secrets/authentik.yaml;

  #jabbi.services.gitlab-runner.enable = true;
  jabbi.docker.enable = true;
  jabbi.services = {
    authentik.enable = true;
    itpms-site.enable = true;
    nextcloud.enable = true;
    nginx.enable = true;
    wireguard.enable = true;
    mail.enable = true;
    uptime-kuma.enable = true;
    ## jabbi.services.fix-ms.enable = true;
    paperless.enable = true;
    wordpress.enable = true;
    resticSecrets.enable = true;
  };

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

  networking.firewall.allowedTCPPorts = [
    80
    443
    25565
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  system.stateVersion = "21.11";

  nix.sshServe.enable = true;
  nix.sshServe.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
  ];
  nix.sshServe.protocol = "ssh-ng";
}
