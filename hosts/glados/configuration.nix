{ config, pkgs, nixpkgs, inputs, lib, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  jabbi = {
    home = {
      enable = true;
      enableVisualApps = true;
    };
    i3wm.enable = true;
    services = {
      gnome.enable = true;
    };
    docker.enable = true;
    #hardware.nvidia.enable = true;
  };
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;
  #boot.tmp.useTmpfs = true;
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" "armv7l-linux" "mips-linux" "riscv32-linux"];
    preferStaticEmulators = true; # Make it work with Docker
  };

  #boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_1;

  #services.xserver.desktopManager.plasma5.enable = true;
  programs.ssh.startAgent = true;
  programs.zsh.enable = true;
  programs.steam.enable = true;

  networking.hostName = "GLaDOS";

  hardware.bluetooth.enable = true;
  programs.nix-ld.enable = true;

  programs.fuse.userAllowOther = true;

  virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.docker.enableNvidia = true;
  users.extraGroups.vboxusers.members = [ "jabbi" ];
  networking.wireless.userControlled.enable = true;

  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  hardware.nvidia.powerManagement.enable = true;
  # see https://github.com/NixOS/nixpkgs/issues/353990
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  # reboot your computer after adding those lines
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';
  services.printing.enable = true;

  time.timeZone = "Europe/Amsterdam";

  programs.adb.enable = true;

  users.users.jabbi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "libvirtd" "adbusers" "scanner" "lp" "wireshark" ];
    hashedPassword = "$6$rejDSpuy6d$za9N7miMI/XHZNjZ6ib0IcaF511UdBn7QVwIV7MO1MTMO5yjVGwuvVT7kJlnTN165srbPd6rCJxtgdABTuEbj1";
    shell = pkgs.zsh;
  };

  users.mutableUsers = false;

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
  ];

  environment.systemPackages = with pkgs; [
    vim
    dig
    htop
    steam-run-native
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  programs.ssh.askPassword = pkgs.lib.mkForce "";

  # Webkit
  environment.variables.WEBKIT_DISABLE_COMPOSITING_MODE = "1";
  environment.variables.WLR_NO_HARDWARE_CURSORS = "1";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/e7a87461-a0d4-470d-ba3b-d9a7ca417d2e";
      preLVM = true;
      bypassWorkqueues = true;
    };
  };

  system.stateVersion = "21.11";
}
