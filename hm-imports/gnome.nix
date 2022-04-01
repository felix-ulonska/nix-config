{ lib, ... }: {
  dconf.settings = {
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "pop-shell@system76.com"
      ];
      "welcome-dialog-last-shown-version" = "41.4";
    };
    "org/gnome/desktop/wm/keybindings" = {
      "maximize" = [ ];
      "minimize" = [ ];
      "move-to-monitor-down" = [ ];
      "move-to-monitor-left" = [ ];
      "move-to-monitor-right" = [ ];
      "unmaximize" = [ ];
      "move-to-workspace-left" = [ "<Super>j" ];
      "move-to-workspace-right" = [ "<Super>k" ];
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
    "org/gnome/desktop/wm/keybindings" = {
      "switch-to-workspace-1" = [ "<Super>1" ];
      "switch-to-workspace-2" = [ "<Super>2" ];
      "switch-to-workspace-3" = [ "<Super>3" ];
      "switch-to-workspace-4" = [ "<Super>4" ];
      "switch-to-workspace-left" = [ "<Super>h" ];
      "switch-to-workspace-right" = [ "<Super>l" ];
      "toggle-fullscreen" = [ "<Super>f" ];
    };
    "org/gnome/desktop/input-sources"."sources" = [ ''(xkb", "de+us")'' ];
  };
}
