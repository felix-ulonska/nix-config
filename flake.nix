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

    nur.url = "github:nix-community/nur";

    impermanence.url = "github:nix-community/impermanence";

    base16.url = "github:SenchoPens/base16.nix";
    base16.inputs.nixpkgs.follows = "nixpkgs";

    base16-eva-scheme = {
      url = github:kjakapat/base16-eva-scheme;
      flake = false;
    };

    base16-i3 = {
      url = github:khamer/base16-i3;
      flake = false;
    };

    base16-vim = {
      url = github:chriskempson/base16-vim;
      flake = false;
    };
  };
  outputs = inputs @ { self, nixpkgs, deploy-rs, agenix, simple-nixos-mailserver, home-manager, base16, nur, impermanence, ... }:
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
          impermanence.nixosModule
          home-manager.nixosModules.home-manager
          (lib.my.mapModulesRec' (toString ./modules) import)
          ({ config, ... }: lib.mkMerge [{
            services.getty.greetingLine =
              "<<< Welcome to ${config.system.nixos.label} - Please leave\\l >>>";
          }])
        ];
        specialArgs = { inherit lib; inherit inputs; };
      };

      nixosConfigurations.GLaDOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = lib.flatten [
          ./hosts/glados/configuration.nix
          { nixpkgs.overlays = [ nur.overlay ]; }
          agenix.nixosModule
          base16.nixosModule
          { scheme = "${inputs.base16-eva-scheme}/eva.yaml"; }
          simple-nixos-mailserver.nixosModule
          impermanence.nixosModule
          home-manager.nixosModules.home-manager
          (lib.my.mapModulesRec' (toString ./modules) import)
          ({ config, ... }: lib.mkMerge [{
            services.getty.greetingLine =
              "<<< Welcome to ${config.system.nixos.label} - Please leave\\l >>>";
          }])
        ];
        specialArgs = { inherit lib; inherit inputs; };
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
          "GLaDOS" = {
            hostname = "localhost";
            sshUser = "root";
            sshOpts = [ "-p" "2222" ];
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."GLaDOS";
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
          function deployGLaDOS() {
            nix run --show-trace github:serokell/deploy-rs .#GLaDOS
          }
        '';
      };
    };
}
