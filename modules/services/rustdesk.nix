{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.jabbi.services.rustdesk;
in
{
  options.jabbi.services.rustdesk = {
    enable = mkEnableOption "Enable Rustdesk";
  };
  config = mkIf cfg.enable {
    services.rustdesk-server.enable = true;
  };
}
