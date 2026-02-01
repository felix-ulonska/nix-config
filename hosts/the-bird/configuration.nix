{
  config,
  pkgs,
  nixpkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

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
  };

  programs.ssh.startAgent = true;

  #programs.ssh.startAgent = true;
  programs.zsh.enable = true;
  programs.steam.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];

  services.logind.settings.Login.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  services.printing = {
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      hplip
    ];
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
  };
  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = false;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };

  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  networking.hostName = "the-bird";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;
  programs.nix-ld.enable = true;

  # this is needed to get a bridge with DHCP enabled
  virtualisation.libvirtd.enable = true;

  programs.fuse.userAllowOther = true;
  networking.firewall.enable = true;

  services.tailscale.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "jabbi" ];
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  # See https://github.com/NixOS/nixpkgs/issues/224332
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.adb.enable = true;

  users.users.jabbi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "libvirtd"
      "adbusers"
      "scanner"
      "lp"
      "dialout"
    ];
    hashedPassword = "$6$rejDSpuy6d$za9N7miMI/XHZNjZ6ib0IcaF511UdBn7QVwIV7MO1MTMO5yjVGwuvVT7kJlnTN165srbPd6rCJxtgdABTuEbj1";
    shell = pkgs.zsh;
  };

  users.mutableUsers = false;
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ+BFtjE8D9+wVAnZ7IrhkTPlA62jdEq037+PaKCXkM jabbi@mimo"
  ];

  environment.systemPackages = with pkgs; [
    vim
    htop
    wireguard-tools
  ];

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.4/32" ];
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

  programs._1password.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "jabbi" ];
  programs._1password-gui.enable = true;

  networking.firewall.allowedTCPPorts = [ 22000 ];

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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  services.printing.enable = true;
  system.stateVersion = "23.11"; # Did you read the comment?
}
