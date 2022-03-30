{ lib, config, ... }:
with lib;
let
  cfg = config.jabbi.gnome;
in
{
  options.jabbi.gnome = {
    enable = mkEnableOption "Enable Gnome";
  };
  config = mkIf cfg.enable {
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.enable = true;
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = true;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
    ];

    dconf.settings = {
      "org/gnome/shell"."enabled-extensions" = [
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };
  };
}
