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
  #boot.tmp.useTmpfs = true;

  services.xserver.desktopManager.plasma5.enable = true;
  programs.ssh.startAgent = true;
  programs.zsh.enable = true;
  programs.steam.enable = true;

                nixpkgs.config.permittedInsecurePackages = [
                "electron-25.9.0"
              ];



  networking.hostName = "GLaDOS";

  hardware.bluetooth.enable = true;
  programs.nix-ld.enable = true;

  # this is needed to get a bridge with DHCP enabled
  virtualisation.libvirtd.enable = true;

  programs.fuse.userAllowOther = true;
  networking.firewall.enable = false;
  #hardware.opentabletdriver.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.docker.enableNvidia = true;
  users.extraGroups.vboxusers.members = [ "jabbi" ];
  networking.wireless.userControlled.enable = true;

  # See https://github.com/NixOS/nixpkgs/issues/224332
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # reboot your computer after adding those lines
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';
  specialisation = {
    disable-nvidia.configuration = {
      boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
    '';
  
    services.udev.extraRules = ''
      # Remove NVIDIA USB xHCI Host Controller devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA USB Type-C UCSI devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA Audio devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA VGA/3D controller devices
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
    '';
    boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
    };
  };

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

  environment.systemPackages = with pkgs; [
    vim
    dig
    htop
    steam-run-native
    wireguard-tools
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ ];

  nix = {
    package = pkgs.nixVersions.stable; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    binaryCaches = [
      "https://formosa-crypto.cachix.org"
    ];
    binaryCachePublicKeys = [
      "formosa-crypto.cachix.org-1:Ds5Tmop43AtcuyZfnoYecemtwLd7DldUruCv5ZV/JUM="
    ];
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
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
    };
  };

  system.stateVersion = "21.11";
}
