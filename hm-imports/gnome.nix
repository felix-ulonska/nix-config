{ lib, ... }: {
  dconf.settings = {
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "pop-shell@system76.com"
        "dash-to-dock@micxgx.gmail.com"
        "org.keepassxc.KeePassXC.desktop"
      ];
      "favorite-apps" = [
        "org.gnome.Geary.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Nautilus.desktop"
        "Alacritty.desktop"
        "firefox.desktop"
        "logseq.desktop"
      ];
      "welcome-dialog-last-shown-version" = "41.4";
    };
    "org/gnome/shell/extensions/pop-shell"."tile-by-default" = false;
    "org/gnome/desktop/wm/keybindings" = {
      "maximize" = [ ];
      "minimize" = [ ];
      "move-to-monitor-down" = [ ];
      "move-to-monitor-left" = [ ];
      "move-to-monitor-right" = [ ];
      "unmaximize" = [ ];
      "move-to-workspace-left" = [ "<Shift><Super>j" ];
      "move-to-workspace-right" = [ "<Shift><Super>k" ];
      "switch-to-workspace-1" = [ "<Super>1" ];
      "switch-to-workspace-2" = [ "<Super>2" ];
      "switch-to-workspace-3" = [ "<Super>3" ];
      "switch-to-workspace-4" = [ "<Super>4" ];
      "switch-to-workspace-left" = [ "<Shift><Super>h" ];
      "switch-to-workspace-right" = [ "<Shift><Super>l" ];
      "toggle-fullscreen" = [ "<Super>f" ];
    };
    "org/gnome/shell/keybindings" = {
      "switch-to-application-1" = [ ];
      "switch-to-application-2" = [ ];
      "switch-to-application-3" = [ ];
      "switch-to-application-4" = [ ];
    };
    "org/gnome/mutter/keybindings" = {
      "toggle-tiled-left" = [ ];
      "toggle-tiled-right" = [ ];
    };
    "org/gnome/desktop/input-sources"."sources" = [ ''("xkb", "de+us")'' ];
    "org/gnome/desktop/interface"."color-scheme" = "prefer-dark";
    "org/gnome/desktop/peripherals/touchpad" = {
      "two-finger-scrolling-enabled" = true;
      "tap-to-click" = true;
    };
  };
}
