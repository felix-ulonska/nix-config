{
  description = "An example NixOS configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
    };
  };
  outputs = { self, nixpkgs, deploy-rs }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
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

      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [
          pkgs.lefthook
          pkgs.nixpkgs-fmt
        ];
        shellHook = ''
          lefthook install
          function deploy() {
            nix run --show-trace github:serokell/deploy-rs
          }
        '';
      };
    };
}
