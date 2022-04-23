# see https://github.com/SenchoPens/senixos/blob/master/profiles/sway/default.nix
{ config, lib, pkgs, inputs, scheme, ... }:

let
  modifier = "Mod4";
  alacritty = "${pkgs.alacritty}/bin/alacritty";
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      terminal = alacritty;
      modifier = modifier;

      gaps = {
        smartBorders = "on";
        smartGaps = true;
      };

      defaultWorkspace = "workspace number 1";

      startup = [
        { command = "autorandr -c"; notification = false; always = true; }
        { command = "timeular --disable-gpu-sandbox"; notification = false; }
        { command = "keepassxc"; notification = false; }
        { command = "logseq"; notification = false; }
        { command = "xclip"; notification = false; }
        { command = "flameshot"; notification = false; }
        { command = "nm-applet"; notification = false; }
      ];

      window.commands = [
        {
          command = "move scratchpad";
          criteria = { class = "KeePassXC"; };
        }
        {
          command = "move scratchpad";
          criteria = { class = "Logseq"; };
        }
        {
          command = "move scratchpad";
          criteria = { class = "Timeular"; };
        }
      ];

      keybindings = {
        "${modifier}+Return" = "exec alacritty";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+d" = "exec rofi -show run";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        "${modifier}+b" = "split h";
        "${modifier}+v" = "split v";
        "${modifier}+f" = "fullscreen toggle";

        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";

        "${modifier}+shift+s" = "sticky toggle";

        "${modifier}+a" = "focus parent";

        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "scratchpad show";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+Shift+1" =
          "move container to workspace number 1";
        "${modifier}+Shift+2" =
          "move container to workspace number 2";
        "${modifier}+Shift+3" =
          "move container to workspace number 3";
        "${modifier}+Shift+4" =
          "move container to workspace number 4";
        "${modifier}+Shift+5" =
          "move container to workspace number 5";
        "${modifier}+Shift+6" =
          "move container to workspace number 6";
        "${modifier}+Shift+7" =
          "move container to workspace number 7";
        "${modifier}+Shift+8" =
          "move container to workspace number 8";
        "${modifier}+Shift+9" =
          "move container to workspace number 9";
        "${modifier}+Shift+0" =
          "move container to workspace number 10";

        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";
        "${modifier}+Shift+e" =
          "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

        "${modifier}+r" = "mode resize";

        "${modifier}+p" = ''[class="KeePassXC"] scratchpad show'';
        "${modifier}+t" = ''[class="Timeular"] scratchpad show'';
        "${modifier}+n" = ''[class="Logseq"] scratchpad show'';
      };

      floating = {
        criteria = [
          { "class" = "KeePassXC"; }
          { "class" = "Logseq"; }
          { "class" = "timeular"; }
        ];
      };

      colors = with scheme.withHashtag; rec {
        background = base00;

        unfocused = {
          text = base04;
          indicator = base07;

          border = background;
          inherit background;
          childBorder = background;
        };
        focusedInactive = unfocused;

        urgent = unfocused // {
          text = base07;

          border = orange;
          childBorder = orange;
        };

        focused = unfocused // (
          let
            focused-bg = base01;
          in
          {
            text = base04;

            childBorder = focused-bg;
            border = focused-bg;
            background = focused-bg;
          }
        );
      };
      bars = [
        {
          id = "bottom";

          colors = with scheme.withHashtag; let
            default = {
              background = base00;
              border = base00;
            };
          in
          {
            background = default.background;
            statusline = base04;
            separator = base04;
            focusedWorkspace = default // { background = base01; text = base04; };
            activeWorkspace = default // { background = base01; text = base03; };
            inactiveWorkspace = default // { text = base04; };
            urgentWorkspace = default // { text = orange; };
            bindingMode = default // { text = yellow; };
          };

          # see ../i3blocks for i3block configuration
          #statusCommand = "${pkgs.i3blocks}/bin/i3blocks";
        }
      ];
    };
  };
}

