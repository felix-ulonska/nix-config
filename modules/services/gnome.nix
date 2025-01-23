{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.jabbi.services.gnome;
in
{
  options.jabbi.services.gnome = {
    enable = mkEnableOption "Enable Gnome";
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "de,us";
      xkb.variant = "us,";
      xkb.options = "grp:win_space_toggle";
    };

    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.libinput.enable = true;
    services.udev.packages = with pkgs; [ platformio ];

    hardware.pulseaudio.enable = false;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.pop-shell
      gnomeExtensions.dash-to-dock
      gnomeExtensions.x11-gestures
    ];
  };
}
