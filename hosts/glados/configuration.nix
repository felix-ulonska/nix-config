{ config, pkgs, nixpkgs, inputs, ... }:
let myCustomLayout = pkgs.writeText "xkb-layout" ''
  ! Map umlauts to RIGHT ALT + <key>
  keycode 108 = Mode_switch
  keysym e = e E EuroSign
  keysym c = c C cent
  keysym a = a A adiaeresis Adiaeresis
  keysym o = o O odiaeresis Odiaeresis
  keysym u = u U udiaeresis Udiaeresis
  keysym s = s S ssharp
    
  ! disable capslock
  ! remove Lock = Caps_Lock
'';
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  jabbi.home.enable = true;
  jabbi.home.enableVisualApps = true;
  jabbi.home.impermanence = true;
  #jabbi.i3wm.enable = true;

  networking.hostName = "GLaDOS";
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.enable = true;
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  services.printing.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  time.timeZone = "Europe/Amsterdam";

  users.users.jabbi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ];
    hashedPassword = "$6$rejDSpuy6d$za9N7miMI/XHZNjZ6ib0IcaF511UdBn7QVwIV7MO1MTMO5yjVGwuvVT7kJlnTN165srbPd6rCJxtgdABTuEbj1";
    shell = pkgs.zsh;
  };

  users.mutableUsers = false;
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
  ];

  environment.systemPackages = with pkgs; [
    vim
    gnomeExtensions.appindicator
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=5G" "mode=755" ];
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  #boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/2f195b74-2630-4696-94f1-1041cd765bad";
      preLVM = true;
    };
  };

  system.stateVersion = "21.11";
}
