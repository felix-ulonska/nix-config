{ lib, config, pkgs, ... }:
with lib;
let cfg = config.jabbi.i3wm;
in {
  options.jabbi.i3wm = { enable = mkEnableOption "Enable i3wm"; };
  config = mkIf cfg.enable {
    services.xserver = {
      #enable = true;
      ## layout = "eu";
      #displayManager.defaultSession = "none+i3";
      #desktopManager = {
      #  xterm.enable = false;
      #};
      windowManager.i3 = {
        enable = false;
        #package = pkgs.i3-gaps;
      };
    };
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraPackages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        mako # notification daemon
        alacritty # Alacritty is the default terminal in the config
        dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      ];
    };
  };
}
