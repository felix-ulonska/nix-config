{ ... }: {
  dconf.settings = {
    "org/gnome/shell"."enabled-extensions" = [
      "appindicatorsupport@rgcjonas.gmail.com"
      "pop-shell@system76.com"
    ];
    "org/gnome/desktop/wm/keybindings"."maximize" = [ ];
    "org/gnome/desktop/wm/keybindings"."minimize" = [ ];
    "org/gnome/desktop/wm/keybindings"."move-to-monitor-down" = [ ];
    "org/gnome/desktop/wm/keybindings"."move-to-monitor-left" = [ ];
    "org/gnome/desktop/wm/keybindings"."move-to-monitor-right" = [ ];
    "org/gnome/desktop/wm/keybindings"."switch-to-workspace-right" = [ ];
    "org/gnome/desktop/wm/keybindings"."unmaximize" = [ ];
    "org/gnome/desktop/wm/keybindings"."move-to-workspace-left" = [ "<Super>j" ];
    "org/gnome/desktop/wm/keybindings"."move-to-workspace-right" = [ "<Super>k" ];
    "org/gnome/shell/keybindings"."switch-to-application-1" = [ ];
    "org/gnome/shell/keybindings"."switch-to-application-2" = [ ];
    "org/gnome/shell/keybindings"."switch-to-application-3" = [ ];
    "org/gnome/shell/keybindings"."switch-to-application-4" = [ ];
    "org/gnome/mutter/keybindings"."toggle-tiled-left" = [ ];
    "org/gnome/mutter/keybindings"."toggle-tiled-right" = [ ];
    "org/gnome/desktop/wm/keybindings"."switch-to-workspace-1" = [ "<Super>1" ];
    "org/gnome/desktop/wm/keybindings"."switch-to-workspace-2" = [ "<Super>2" ];
    "org/gnome/desktop/wm/keybindings"."switch-to-workspace-3" = [ "<Super>3" ];
    "org/gnome/desktop/wm/keybindings"."switch-to-workspace-4" = [ "<Super>4" ];
    "org/gnome/desktop/wm/keybindings"."switch-to-workspace-left" = [ "<Super>h" ];
    "org/gnome/desktop/wm/keybindings"."switch-to-workspace-right" = [ "<Super>l" ];
    "org/gnome/desktop/wm/keybindings"."toggle-fullscreen" = [ "<Super>f" ];
    "org/gnome/shell"."welcome-dialog-last-shown-version" = "41.4";
    "org/gnome/desktop/input-sources"."sources" = [ lib.hm.gvariant.mkTuple [ "xkb", "de+us" ] ];
  };
}
