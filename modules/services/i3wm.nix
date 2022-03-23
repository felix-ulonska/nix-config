{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.jabbi.i3wm;
in
{
  options.jabbi.i3wm = {
    enable = mkEnableOption "Enable i3wm";
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "eu";
      displayManager.defaultSession = "xfce+i3";
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };
  };
}
