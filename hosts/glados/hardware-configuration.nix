# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

#{
#  imports =
#    [
#      (modulesPath + "/installer/scan/not-detected.nix")
#    ];
#
#  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "usb_storage" "sd_mod" ];
#  boot.initrd.kernelModules = [ "dm-snapshot" ];
#  boot.kernelModules = [ "kvm-amd" ];
#  boot.extraModulePackages = [ ];
#
#
#  fileSystems."/boot" = {
#    device = "/dev/nvme1n1p1";
#    fsType = "vfat";
#  };
#
#  fileSystems."/nix" =
#    {
#      device = "/dev/disk/by-uuid/8c9022a8-d7be-41aa-a355-0d8ed094f575";
#      fsType = "ext4";
#    };
#
#  fileSystems."/etc/nixos" =
#    {
#      device = "/nix/persist/etc/nixos";
#      fsType = "none";
#      options = [ "bind" ];
#    };
#
#  fileSystems."/var/log" =
#    {
#      device = "/nix/persist/var/log";
#      fsType = "none";
#      options = [ "bind" ];
#    };
#
#  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
#}
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/21a2665f-1415-4e4d-aff6-c8414183b038";
      fsType = "ext4";
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
