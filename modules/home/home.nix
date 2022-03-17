{ lib, config, home-manager, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.jabbi.home;
  hmConfig = { pkgs, inputs, config, ... }: {
    imports = lib.my.mapModulesRec' ../../hm-imports (x: x);
  };
in
{
  options.jabbi.home = {
    enable = mkEnableOption "Enable Homemanager";
  };
  config = mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.jabbi = hmConfig;
  };
}
