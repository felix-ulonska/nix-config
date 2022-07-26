{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.jabbi.services.nix-cache;
in
{
  options.jabbi.services.nix-cache = {
    enable = mkEnableOption "Enable Nix Cache";
  };
  config = mkIf cfg.enable
    {
      age.secrets = {
        cache-priv-key = {
          file = ../../secrets/cache-priv-key.age;
        };
        cache-pub-key = {
          file = ../../secrets/cache-pub-key.age;
        };
      };
      services.nix-serve = {
        enable = true;
        secretKeyFile = "/run/agenix/cache-priv-key";
      };
      services.nginx = {
        virtualHosts = {
          "cloud.webfoo.de" = {
            serverAliases = [ "webfoo" ];
            locations."/".extraConfig = ''
              proxy_pass http://localhost:${toString config.services.nix-serve.port};
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            '';
          };
        };
      };

    };
}
