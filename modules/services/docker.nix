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
    virtualisation.podman.enable = true;
    virtualisation.podman.dockerSocket.enable = true;
    virtualisation.podman.defaultNetwork.dnsname.enable = true;
    virtualisation.oci-containers.backend = "podman";

    # Use your username instead of `myuser`
    users.extraUsers.jabbi.extraGroups = [ "podman" ];
  };
}
