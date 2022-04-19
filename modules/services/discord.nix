{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.jabbi.services.jmusicbot;
in
{
  options.jabbi.services.jmusicbot = {
    enable = mkEnableOption "Enable JMusicBot";
  };
  config = mkIf cfg.enable
    {
      services.jmusicbot = {
        enable = true;
      }
    };

}
