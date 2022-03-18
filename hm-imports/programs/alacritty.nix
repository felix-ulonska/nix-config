{ pkgs, config, inputs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "agave Nerd Font Mono";
          style = "regular";
        };
        size = 12;
      };
    };
  };
}
