{ ... }: {
{ lib, config, ... }:
with lib;
let
  cfg = config.jabbi.services.resticSecrets;
in
{
  options.jabbi.services.resticSecrets = {
    enable = mkEnableOption "Enable resticSecrets";
  };
  config = mkIf cfg.enable {
    age.secrets = {
      resticSecrets = {
        file = ../../secrets/resticSecrets.age;
      };
    };
  };
}
