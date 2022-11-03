{ config, pkgs, nixpkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  jabbi.home.enable = true;
  jabbi.home.enableVisualApps = true;
  jabbi.i3wm.enable = true;
  jabbi.services.gnome.enable = true;
  jabbi.docker.enable = true;
  services.flatpak.enable = true;

  services.usbmuxd.enable = true;

  programs.ssh.startAgent = true;
  programs.steam.enable = true;

  networking.hostName = "GLaDOS";
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.bluetooth.enable = true;
  programs.nix-ld.enable = true;

  # this is needed to get a bridge with DHCP enabled
  virtualisation.libvirtd.enable = true;

  programs.fuse.userAllowOther = true;
  networking.firewall.enable = false;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enableNvidia = true;
  users.extraGroups.vboxusers.members = [ "jabbi" ];
  networking.wireless.userControlled.enable = true;

  # reboot your computer after adding those lines
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';

  boot.supportedFilesystems = [ "ntfs" ];

  services.printing.enable = true;

  time.timeZone = "Europe/Amsterdam";

  programs.adb.enable = true;

  users.users.jabbi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "libvirtd" "adbusers" "scanner" "lp" ];
    hashedPassword = "$6$rejDSpuy6d$za9N7miMI/XHZNjZ6ib0IcaF511UdBn7QVwIV7MO1MTMO5yjVGwuvVT7kJlnTN165srbPd6rCJxtgdABTuEbj1";
    shell = pkgs.zsh;
  };

  users.mutableUsers = false;
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
  ];

  hardware.sane.enable = true;
  hardware.sane.brscan4.enable = true;
  hardware.sane.brscan5.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    dig
    htop
    steam-run-native
    wireguard-tools
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 1433 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  nix = {
    package = pkgs.nixVersions.stable; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  services.xserver.desktopManager.plasma5.enable = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "";

  # Webkit
  environment.variables.WEBKIT_DISABLE_COMPOSITING_MODE = "1";

  #boot.loader.grub = {
  #  enable = true;
  #  version = 2;
  #  device = "nodev";
  #  efiSupport = true;
  #  enableCryptodisk = true;
  #};

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/e7a87461-a0d4-470d-ba3b-d9a7ca417d2e";
      preLVM = true;
    };
  };

  system.stateVersion = "21.11";
}
