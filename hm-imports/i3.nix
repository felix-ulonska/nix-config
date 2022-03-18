# see https://github.com/SenchoPens/senixos/blob/master/profiles/sway/default.nix
{ config, lib, pkgs, inputs, scheme, ... }:

let
  mod = "Mod4";
  alacritty = "${pkgs.alacritty}/bin/alacritty";
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      terminal = alacritty;
      modifier = mod;

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

