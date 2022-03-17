{
  description = "An example NixOS configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
    };
    agenix.url = "github:ryantm/agenix";
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs @ { self, nixpkgs, deploy-rs, agenix, simple-nixos-mailserver, home-manager, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs; lib = self; };
      });
    in
    {
      lib = lib.my;
      nixosModules = lib.my.mapModulesRec ./modules/services import;

      nixosConfigurations.silbervogel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = lib.flatten [
          ./hosts/silbervogel/configuration.nix
          agenix.nixosModule
          simple-nixos-mailserver.nixosModule
          home-manager.nixosModules.home-manager
          (lib.my.mapModulesRec' (toString ./modules) import)
          ({ config, ... }: lib.mkMerge [{
            services.getty.greetingLine =
              "<<< Welcome to ${config.system.nixos.label} - Please leave\\l >>>";
          }])
        ];
        specialArgs = { inherit lib; };
      };

      deploy = {
        nodes = {
          "silbervogel" = {
            hostname = "5.45.111.134";
            sshUser = "root";
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."silbervogel";
            };
          };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [
          pkgs.lefthook
          pkgs.nixpkgs-fmt
          agenix.defaultPackage.x86_64-linux
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
