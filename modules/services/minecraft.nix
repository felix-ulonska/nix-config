{ ... }: {
  virtualisation.oci-containers.containers {
  minecraft: {
  image: "itzg/minecraft-server";
  autoStart = "true";
  ports = [ "25565:25565" ];
  environment = {
    EULA = "TRUE";
    TYPE = "FORGE";
    VERSION = "1.18.1"
      # FORGEVERSION = "39.0.43"
      # MEMORY: "10G"
      };
    volumes = [ "/var/lib/minecraft:/data" ]
      }
      }
      }
