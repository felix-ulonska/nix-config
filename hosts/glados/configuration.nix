{ config, pkgs, nixpkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  jabbi.home.enable = true;
  jabbi.home.enableVisualApps = true;
  #jabbi.home.impermanence = true;
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
  users.extraGroups.vboxusers.members = [ "jabbi" ];

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

  nix = {
    settings = {
      substituters = [
        "http://cache.webfoo.de"
      ];
      trusted-public-keys = [
        "cache.webfoo.de:9zIefd8f6KaimDoy2spawTm6JCzsMlSQtm2yPW5v7DM="
      ];
    };
  };

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
    options = [ "defaults" "size=1G" "mode=755" ];
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/etc/wireguard"
      "/tmp"
      "/root/.cache/nix"
    ]
    ++ (map (x: "/var/lib/" + x) [
      "bluetooth"
      "docker"
      "containers"
      "flatpak"
    ])
    ++
    map (x: "/home/jabbi/" + x) [
      "Downloads"
      "Documents"
      "Nextcloud"
      "Arbeit"
      "opt"
      "Projects"
      ".logseq"
      ".config/Nextcloud"
      ".config/keepassxc"
      ".config/discord"
      ".config/Timeular"
      ".config/nautilus"
      ".config/pulse"
      ".config/Microsoft Teams - Preview"
      ".config/Microsoft"
      ".config/team"
      ".config/spotify"
      ".config/goa-1.0"
      ".config/Logseq"
      ".config/geary"
      ".config/syncthing"
      ".config/JetBrains"
      ".config/UnityHub"
      ".config/unity3d"
      ".gradle"
      #".config"
      ".cache/Cypress"
      ".cache/firebase"
      ".cache/unityhub-updater"
      ".cache/nix"
      ".local/share/containers"
      ".local/share/keyrings"
      ".local/share/Steam"
      ".local/share/geary"
      ".mozilla"
      ".wine"
      ".ssh"
      "Android"
      ".local/share/flatpak"
      ".cargo"
      ".var"
      #".local/share/gnome-settings-daemon"
      #".local/share/gnome-shell"
    ];


    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ] ++ map (x: "/home/jabbi/" + x) [ ".zsh_history" ".config/gnome-initial-setu-done" ".npmrc" ];
  };
  services.xserver.desktopManager.plasma5.enable = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "";

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
