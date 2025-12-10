{
  lib,
  config,
  pkgs,
  ...
}:
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
      xkb = {
        layout = "de,us";
        variant = "us,";
        options = "grp:win_space_toggle";
      };
    };

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    services.libinput.enable = true;
    services.udev.packages = with pkgs; [ platformio ];
    services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.pop-shell
      gnomeExtensions.dash-to-dock
      gnomeExtensions.x11-gestures
    ];
  };
}
