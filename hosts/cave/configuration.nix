{pkgs, ...}: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cave"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.burkhard = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing
  };

  time.timeZone = "Europe/Amsterdam";

  services.printing.drivers = with pkgs; [
    brlaser 
    brgenml1lpr
    brgenml1cupswrapper
    gutenprint
  ];

  environment.systemPackages = with pkgs; [
    ecryptfs
    firefox
    thunderbird
    libreoffice
    zoom-us
    syncthing
    bitwarden

    # kde
    kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
    kdePackages.kcolorchooser # A small utility to select a color
    kdePackages.kolourpaint # Easy-to-use paint program
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdiff3 # Compares and merges 2 or 3 files or directories
    kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
    kdePackages.partitionmanager # Optional Manage the disk devices, partitions and file systems on your computer
    hardinfo2 # System information and benchmarks for Linux systems
    haruna # Open source video player built with Qt/QML and libmpv
    wayland-utils # Wayland utilities
    wl-clipboard # Command-line copy/paste utilities for Wayland
  ];

  users.users.jabbi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "libvirtd" "adbusers" "scanner" "lp" ];
    hashedPassword = "$6$rejDSpuy6d$za9N7miMI/XHZNjZ6ib0IcaF511UdBn7QVwIV7MO1MTMO5yjVGwuvVT7kJlnTN165srbPd6rCJxtgdABTuEbj1";
  };
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
  ];

  services.printing.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  nixpkgs.config.allowUnfree = true;

  i18n.defaultLocale = "de_DE.UTF-8";
  services.xserver = {
    xkb.layout = "de";
  };
  console.keyMap = "de";
  services = {
    xserver.libinput.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;

    comin = {
      enable = true;
      remotes = [{
        name = "origin";
        url = "https://github.com/felix-ulonska/nix-config.git";
        branches.main.name = "main";
      }];
    };
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.3/32" ];
      listenPort = 51820; 
      privateKeyFile = "/etc/wireguardKeys/private";

      peers = [
        {
          publicKey = "IFDOKRBtVSIDK3/KMGov35o4geKXWoN5yaGsfVJ65Wc=";
          allowedIPs = [ "10.100.0.0/24" ];
          endpoint = "152.53.47.93:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # ecryptfs
  security.pam.enableEcryptfs = true;
  boot.kernelModules = ["ecryptfs"];

  system.stateVersion = "25.05";
}
