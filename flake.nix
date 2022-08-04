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

    itpms-site.url = "gitlab:itpms/website";

    theme = {
      url = github:ajlende/base16-atlas-scheme;
      #url = "github:hakatashi/base16-colors-scheme";
      #url = "github:atelierbram/base16-atelier-schemes";
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
    base16-zathura = {
      url = github:haozeke/base16-zathura;
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ { self, nixpkgs, deploy-rs, agenix, simple-nixos-mailserver, home-manager, base16, nur, impermanence, flake-utils, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs; lib = self; };
      });
      modulesList = lib.flatten [
        agenix.nixosModule
        simple-nixos-mailserver.nixosModule
        impermanence.nixosModule
        base16.nixosModule
        { scheme = "${inputs.theme}/atlas.yaml"; }
        #{ scheme = "${inputs.theme.outPath}/atelier-cave-light.yaml"; }
        #{ scheme = "${inputs.theme}/atelier-savanna.yaml"; }
        home-manager.nixosModules.home-manager
        (lib.my.mapModulesRec' (toString ./modules) import)
        ({ config, ... }: lib.mkMerge [{
          services.getty.greetingLine =
            "<<< Welcome to ${config.system.nixos.label} - Please leave\\l >>>";
        }])
        { nixpkgs.overlays = [ nur.overlay ]; }
      ];
    in
    {
      lib = lib.my;
      nixosModules = lib.my.mapModulesRec ./modules/services import;
      outputFoo = (modulesList ++ [ ./hosts/silbervogel/configuration.nix ]);


      nixosConfigurations.fact-cube =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib; inherit inputs; };
          modules = (modulesList ++ [ ./hosts/fact-cube/configuration.nix ]);
        };
      nixosConfigurations.GLaDOS =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib; inherit inputs; };
          modules = (modulesList ++ [ ./hosts/glados/configuration.nix ]);
        };

      nixosConfigurations.edgeless-safety-cube =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib; inherit inputs; };
          modules = (modulesList ++ [ ./hosts/edgeless-safety-cube/configuration.nix ]);
        };

      deploy = {
        nodes = {
          "fact-cube" = {
            hostname = "fact-cube.webfoo.de";
            sshUser = "root";
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."fact-cube";
            };
          };
          "GLaDOS" = {
            hostname = "localhost";
            sshUser = "root";
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."GLaDOS";
              magicRollback = false;
              sshOpts = [ "-o" "StrictHostKeyChecking=no" ];
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
          function buildVM () {
            sudo nixos-rebuild build-vm --flake .#edgeless-safety-cube
          }
          function deployNoSafe() {
            nix run --show-trace github:serokell/deploy-rs -- --auto-rollback false
          }
          function deploy() {
            nix run --show-trace github:serokell/deploy-rs
          }
          function deployGLaDOS() {
            nix run --show-trace github:serokell/deploy-rs .#GLaDOS
          }
          function deployFactCube() {
            nix run --show-trace github:serokell/deploy-rs .#fact-cube
          }
        '';
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # I re-export deploy-rs due to an issue with running `nix flake github:serokell/deploy-rs ...`
        # per a conversation I had here: https://github.com/serokell/deploy-rs/issues/155
        apps.deploy-rs = {
          program = deploy-rs.defaultApp."${system}";
          type = "app";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            deploy-rs.defaultPackage."${system}"
            agenix.defaultPackage."${system}"
          ];
        };
      });
}
