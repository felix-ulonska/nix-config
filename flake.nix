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
      sshUser = "root";           # SSH login username
      user = "root";              # Remote username
      nodes = {
        "nixos" = {
          # Target node's address, either IP, domain, or .ssh/config alias
          hostname = "5.45.111.134";
          profiles.system = {
            # Use nixosConfigurations."nixos" defined above
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."nixos";
          };
        };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
  };
}
