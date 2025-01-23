{ lib, config, ... }:
with lib;
let
  cfg = config.jabbi.docker;
in
{
  options.jabbi.docker = {
    enable = mkEnableOption "Enable ForgeServer";
  };
  config = mkIf cfg.enable {

    # Use your username instead of `myuser`
    users.extraGroups.docker.members = [ "jabbi" ];
  };
}
