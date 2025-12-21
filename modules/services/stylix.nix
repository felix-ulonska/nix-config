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
  services.getty.greetingLine = "<<< Welcome to ${config.system.nixos.label} - Please leave\\l >>>";
  #stylix.image = backgroundImg; # inputs.background.outPath;
  stylix.image = config.lib.stylix.pixel "base00";
  stylix.base16Scheme = "${inputs.theme}/eva.yaml";
  #stylix.targets.hyprland.enable = true;
  stylix.polarity = "dark";
  stylix.fonts.monospace = {
    package = (pkgs.nerd-fonts.agave);
    name = "agave Nerd Font Mono";
  };
  stylix.fonts.sansSerif = {
    package = (pkgs.nerd-fonts.agave);
    name = "agave Nerd Font";
  };
}
