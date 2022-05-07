{ pkgs, lib, config, nixpkgs, modulesPath, ... }:

with lib;
{
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  config = {
    services.qemuGuest.enable = true;
    #jabbi.home.enable = true;
    #jabbi.home.userName = "hacker";

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot = {
      growPartition = true;
      loader.timeout = 5;
    };

    virtualisation = {
      diskSize = 15000; # MB
      memorySize = 8048; # MB
      writableStoreUseTmpfs = false;
      resolution = { x = 1920; y = 1080; };
      cores = 6;
      # Prevent read of host nixstore
      # true to prevent read of /nix/store but takes storage
      useNixStoreImage = false;

      sharedDirectories = {
        #share = { 
        #  source = "/tmp/mount";
        #  target = "/shared";
        #};
      };
      qemu = {
        networkingOptions = lib.mkForce [ "-nic none" ];
      };
      writableStore = false;
      graphics = false;
    };

    nixpkgs.config.pulseaudio = true;

    #services.xserver = {
    #  enable = true;
    #  desktopManager = {
    #    xterm.enable = false;
    #    xfce.enable = true;
    #  };
    #  displayManager.autoLogin = {
    #    enable = true;
    #    user = "hacker";
    #  };
    #  displayManager.defaultSession = "xfce";
    #};

    services.openssh.enable = true;
    services.openssh.permitRootLogin = "yes";

    programs.wireshark.enable = true;

    environment.systemPackages = with pkgs;
      [
        # some relevant packages here
        firefox
        neovim
        htop
        ghidra
        wget
        wireshark
      ];

    users.users.hacker = {
      isNormalUser = true;
      home = "/home/user";
      description = "hacker";
      password = "password";
      extraGroups = [ "wheel" "networkmanager" ];
      # openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3Nza... alice@foobar" ];
    };

    # This is bad, but you know what you are doing, I hope
    users.users.root.password = "rootroot"; # oops
    users.mutableUsers = false;
  };
}
