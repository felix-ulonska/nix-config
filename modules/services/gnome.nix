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
      xkbVariant = "us,";
      xkbOptions = "grp:win_space_toggle";
    };

    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = true;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.pop-shell
    ];
  };
}
