{ config, pkgs, inputs, backgroundImg, ... }: {
  home.packages = with pkgs; [
    nwg-dock-hyprland
    swaylock
    dunst
    grim
    slurp
    swaybg
  ];
  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = 1;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  wayland.windowManager.hyprland.extraConfig = ''
        exec-once = swaybg --image ${config.stylix.image} --mode center
        $mod = SUPER
        bind=$mod,F,fullscreen
        bind=$mod,M, exec, swaylock
        bind = , Print, exec, grimblast copy area
        env = WLR_NO_HARDWARE_CURSORS,1
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        ${builtins.concatStringsSep "\n" (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in ''
              bind = $mod, ${ws}, workspace, ${toString (x + 1)}
              bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
            ''
          )
          10)}

    #exec-once = nwg-dock-hyprland -d -f -x -f -p left
    exec-once = swayidle -w timeout 600 "swaylock" before-sleep "swaylock"
    # exec-once = waybar & hyprpaper & firefox
    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor=,highres,auto,1


    # See https://wiki.hyprland.org/Configuring/Keywords/ for more

    # Execute your favorite apps at launch
    # exec-once = waybar & hyprpaper & firefox
    exec-once = dunst

    # Source a file (multi-file configs)
    # source = ~/.config/hypr/myColors.conf

    # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
    input {
        kb_layout = eu
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =

        follow_mouse = 1

        touchpad {
            natural_scroll = no
        }

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }

    general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5
        gaps_out = 20
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)

        layout = dwindle
    }

    decoration {
        rounding = 10
    }

    animations {
        enabled = yes

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    dwindle {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = yes # you probably want this
    }

    master {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    }

    gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = on
    }


    $mainMod = SUPER

    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = $mainMod, Q, exec, alacritty
    bind = $mainMod, C, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, dolphin
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, D, exec, rofi -show run
    #bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, S, togglesplit, # dwindle
    bind = $mainMod, P, exec, grim -g "$(slurp)" - | wl-copy

    # Move focus with mainMod + arrow keys
    bind = $mainMod,H, movefocus, l
    bind = $mainMod,L, movefocus, r
    bind = $mainMod,J, movefocus, u
    bind = $mainMod,K, movefocus, d

    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

        # ...
    source=~/.config/hypr/monitors.conf
  '';

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [{
      style = ''
        *{ 
          font-family: Agave Nerd Font Mono;
          border: none;
          border-radius: 0;
          font-family: Source Code Pro;
        }
      '';
      height = 30;
      layer = "top";
      position = "bottom";
      tray = { spacing = 10; };
      modules-center = [ "hyprland/window" ];
      modules-left = [ "hyprland/workspaces" ];
      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
      ]
      ++ [
        "clock"
        "tray"
      ];
      battery = {
        format = "{capacity}% {icon}";
        format-alt = "{time} {icon}";
        format-charging = "{capacity}% ";
        format-icons = [ "" "" "" "" "" ];
        format-plugged = "{capacity}% ";
        states = {
          critical = 15;
          warning = 30;
        };
      };
      clock = {
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
      };
      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };
      memory = { format = "{}% "; };
      network = {
        interval = 1;
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        format-disconnected = "Disconnected ⚠";
        format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
        format-linked = "{ifname} (No IP) ";
        format-wifi = "{essid} ({signalStrength}%) ";
      };
      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-icons = {
          car = "";
          default = [ "" "" "" ];
          handsfree = "";
          headphones = "";
          headset = "";
          phone = "";
          portable = "";
        };
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        on-click = "pavucontrol";
      };
      "sway/mode" = { format = ''<span style="italic">{}</span>''; };
      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = [ "" "" "" ];
      };
    }];
  };
}
