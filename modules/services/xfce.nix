{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.jabbi.services.xfce;
in
{
  options.jabbi.services.xfce = {
    enable = mkEnableOption "Enable XFCe";
  };
  config = mkIf cfg.enable {
  nixpkgs.config.pulseaudio = true;

  services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };
      displayManager.defaultSession = "xfce";
    };
  };
}

