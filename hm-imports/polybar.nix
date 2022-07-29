# see https://github.com/SenchoPens/senixos/blob/master/profiles/sway/default.nix
{ config, lib, pkgs, inputs, scheme, ... }:
{
  config.services.polybar = with scheme.withHashtag; {
    enable = true;
    package = pkgs.polybarFull;
    config = {
      "bar/bottom" = {
        bottom = true;
        width = "100%";
        height = "3%";
        radius = 10;
        modules-right = "wireless wired battery memory cpu";
        modules-center = "date";
        modules-left = "i3";
        background = base00;
        foreground = base05;
        line-color = base07;
        border-color = base0E;
        module-margin = 1;
        font-0 = "FiraCode Nerd Font Mono:size=13";
        separator = "|";
        tray-position = "right";
      };
      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%d.%m.%y";
        time = "%H:%M";
        label = "%time%  %date%";
      };
      "module/battery" = {
        type = "internal/battery";
        full-at = 99;
        low-at = 10;
        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-framerate = "750";
        animation-discharging-0 = '''';
        animation-discharging-1 = '''';
        animation-discharging-2 = '''';
        animation-discharging-3 = '''';
        animation-discharging-4 = '''';
        animation-discharging-framerate = 500;

        label-charging = "Charging %percantage% %consumption%";
        format-charging = "<animation-charging> <label-charging>";
        format-discharging = "<ramp-capacity> <label-discharging>";
        label-discharging = "Discharging %percentage%% %consumption%";
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        label-full = "Fully charged %consumption% W";
      };
      "module/i3" = {
        type = "internal/i3"; 
        label-focused-background = base01;
        label-separator = ''|'';
        label-focused-padding = 2;
        label-unfocused-padding = 2;
        label-visible-padding = 2;
        label-separator-padding = 2;
        format = "<label-state>";
        label-focused = "%name%";
        label-unfocused = "%name%";
        label-visible = "%name%";
        label-urgent = "%name%";
      };
      "module/cpu" = {
        type = "internal/cpu";
        format = " <label> <ramp-coreload>";
        label = "CPU";
        ramp-coreload-spacing = 0;
        ramp-coreload-0 = "▁";
        ramp-coreload-1 = "▂";
        ramp-coreload-2 = "▃";
        ramp-coreload-3 = "▄";
        ramp-coreload-4 = "▅";
        ramp-coreload-5 = "▆";
        ramp-coreload-6 = "▇";
        ramp-coreload-7 = "█";
      };                    
      "module/memory" = {
        type = "internal/memory";
        format = "<label>";
        label = "RAM %gb_free% SWAP %gb_swap_free%";
        bar-used-width = 50;
        #bar-used-foreground-0 = #55aa55;
        #bar-used-foreground-1 = #557755
        #bar-used-foreground-2 = #f5a70a
        #bar-used-foreground-3 = #ff5555
        bar-used-fill = "▐";
        bar-used-empty = "▐";
        #bar-used-empty-foreground = #444444
      };
      "module/wired" = {
        type = "internal/network";
        interface = "eno1";
      };
      "module/wireless" = {
        type = "internal/network";
        interface = "wlp4s0";
      };
      "colors" =  {
        base00 = base00;
        base01 = base01;
        base02 = base02;
        base03 = base03;
        base04 = base04;
        base05 = base05;
        base06 = base06;
        base07 = base07;
        base08 = base08;
        base09 = base09;
        base0A = base0A;
        base0B = base0B;
        base0C = base0C;
        base0D = base0D;
        base0E = base0E;
        base0F = base0F;
      };
    };
    script = ''
      polybar bottom &
    '';
  };
}
