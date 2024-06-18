{ pkgs, config, inputs, scheme, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        #normal = {
        #  family = "agave Nerd Font Mono";
        #  style = "regular";
        #};
        #size = 12;
      };
      #colors =
      #  with scheme.withHashtag; let
      #    default = {
      #      black = base00;
      #      white = base07;
      #      inherit red green yellow blue cyan magenta;
      #    };
      #  in
      #  {
      #    primary = { background = base00; foreground = base07; };
      #    cursor = { text = base02; cursor = base07; };
      #    normal = default;
      #    bright = default;
      #    dim = default;
      #  };
    };
  };
}
