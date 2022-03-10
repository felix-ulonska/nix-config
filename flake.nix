{
  description = "An example NixOS configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
    };
  };
  outputs = { self, nixpkgs, deploy-rs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];  
    };

    deploy = {
      nodes = {
        "nixos" = {
          hostname = "5.45.111.134";
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."nixos";
          };
        };
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
