{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.jabbi.hardware.nvidia;
in
{
  options.jabbi.hardware.nvidia = {
    enable = mkEnableOption "Enable Nvidia";
  };

  config = mkIf cfg.enable {
    hardware.opengl.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.modesetting.enable = true;
    # hardware.nvidia.powerManagement.finegrained = true;
    #hardware.nvidia.nvidiaPersistenced = true;
    hardware.nvidia.prime = {
      offload.enable = true;
      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:6:0:0";
    };

    #hardware.nvidia.powerManagement.enable = true;

    #specialisation = {
    #  external-display.configuration = {
    #    system.nixos.tags = [ "external-display" ];
    #    hardware.nvidia.prime.offload.enable = lib.mkForce false;
    #    hardware.nvidia.powerManagement.enable = lib.mkForce false;
    #  };
    #};

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "nvidia-offload" ''
        export lspci -vnnn | perl -lne 'print if /^\d+\:.+(\[\S+\:\S+\])/' | grep VGA__NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@" '')
    ];
  };
}
