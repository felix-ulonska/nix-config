{
  config,
  inputs,
  pkgs,
  ...
}:
{
  stylix.enable = true;
  stylix.opacity.terminal = 1.0;
  stylix.opacity.applications = 1.0;
  #stylix.image = backgroundImg; # inputs.background.outPath;
  stylix.image = config.lib.stylix.pixel "base00";
  stylix.base16Scheme = "${inputs.theme}/atelier-cave-light.yaml";
  #stylix.targets.hyprland.enable = true;
  stylix.polarity = "light";
  stylix.fonts.monospace = {
    package = (pkgs.nerd-fonts.agave);
    name = "agave Nerd Font Mono";
  };
  stylix.fonts.sansSerif = {
    package = (pkgs.nerd-fonts.agave);
    name = "agave Nerd Font";
  };
}
