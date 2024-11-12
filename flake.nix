{
  description = "An example NixOS configuration";

  inputs = {
    #nixpkgs = { url = "path:/home/jabbi/Projects/nixpkgs"; };
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixpkgsMaster = { url = "github:nixos/nixpkgs/master"; };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
    };
    agenix.url = "github:ryantm/agenix";
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/";
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    impermanence.url = "github:nix-community/impermanence";

    base16.url = "github:SenchoPens/base16.nix/def69d6edc32792562975aec863dbef757f832cf";
    base16.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/c1cfbfad7cb45f0c177b35b59ba67d1b5fc7ca82";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    itpms-site.url = "gitlab:itpms/website";
    fix-ms-backend.url = "github:Fix-MS/backend/deployment";
    fix-ms-frontend.url = "github:Fix-MS/app";

    felixnixvim.url = "github:felix-ulonska/vim";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
     # submodules = true;
    };

    background = {
      #url = "https://i.redd.it/hirdcwgy29981.jpg";
      url = "https://i.redd.it/yuxe7ow1wyy91.png"; # Sanfransico
      #url = ./assets/rhein.jpg;
      flake = false;
    };

    fix-ms-prasentation = {
      url = "github:Fix-MS/prasentation";
      flake = false;
    };

    theme = {
      #url = github:ajlende/base16-atlas-scheme;
      #url = github:b3nj5m1n/base16-pinky-scheme;
      #url = github:Misterio77/base16-nebula-scheme;
      #url = github:jcornwall/base16-woodland-scheme;
      #url = github:vic/base16-rebecca;
      #url = github:chriskempson/base16-vim;
      #url = "github:hakatashi/base16-colors-scheme";
      #url = "github:atelierbram/base16-atelier-schemes";
      #url = "github:tinted-theming/base16-schemes";
      #url = "github:chawyehsu/base16-snazzy-scheme";
      url = github:kjakapat/base16-eva-scheme;
      flake = false;
    };

    base16-i3 = {
      url = "github:khamer/base16-i3";
      flake = false;
    };

    base16-vim = {
      url = "github:chriskempson/base16-vim";
      flake = false;
    };
    base16-zathura = {
      url = "github:haozeke/base16-zathura";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ { self, nixpkgs, deploy-rs, agenix, simple-nixos-mailserver, home-manager, base16, nur, impermanence, flake-utils, fix-ms-backend, stylix, background, nixos-hardware, nixpkgsMaster, felixnixvim, disko, lix-module, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs; lib = self; };
      });
      backgroundImg = background;
      modulesList = lib.flatten [
        agenix.nixosModules.default
        simple-nixos-mailserver.nixosModule
        impermanence.nixosModule
        lix-module.nixosModules.default
        base16.nixosModule
        { scheme = "${inputs.theme}/eva.yaml"; }
        #{ scheme = "${inputs.theme.outPath}/atelier-heath-light.yaml"; }
        #{ scheme = ./assets/summerfruit-light.yaml; }
        #{ scheme = "${inputs.theme}/snazzy.yaml"; }
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        (lib.my.mapModulesRec' (toString ./modules) import)
        ({ config, ... }: lib.mkMerge [{
          stylix.enable = true;
          stylix.opacity.terminal = 1.0;
          stylix.opacity.applications = 1.0;
          services.getty.greetingLine =
            "<<< Welcome to ${config.system.nixos.label} - Please leave\\l >>>";
          #stylix.image = backgroundImg; # inputs.background.outPath;
          stylix.image = config.lib.stylix.pixel "base0A";
          stylix.base16Scheme = "${inputs.theme}/eva.yaml";
          stylix.polarity = "dark";
          stylix.fonts.monospace = {
            package = (pkgs.nerdfonts.override { fonts = [ "Agave" ]; });
            name = "agave Nerd Font Mono";
          };
          stylix.fonts.sansSerif = {
            package = (pkgs.nerdfonts.override { fonts = [ "Agave" ]; });
            name = "agave Nerd Font";
          };
          #scheme = config.lib.stylix.colors;
        }])
      ];
    in
    {
      lib = lib.my;
      nixosModules = lib.my.mapModulesRec ./modules/services import;
      outputFoo = modulesList ++ [ ./hosts/silbervogel/configuration.nix ];

      nixosConfigurations.fact-cube =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib; inherit inputs backgroundImg; };
          modules = lib.flatten [
              agenix.nixosModules.default
              simple-nixos-mailserver.nixosModule
              impermanence.nixosModule
              (lib.my.mapModulesRec' (toString ./modules/services) import)
              ./hosts/fact-cube/configuration.nix ];
        };
      nixosConfigurations.GLaDOS =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib; inherit inputs backgroundImg; };
          modules = modulesList ++ [
            ./hosts/glados/configuration.nix
            nixos-hardware.nixosModules.lenovo-legion-16ach6h
            inputs.hyprland.nixosModules.default
            { programs.hyprland.enable = true; }
          ];
        };
      nixosConfigurations.the-bird =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib; inherit inputs backgroundImg; };
          modules = modulesList ++ [
            ./hosts/the-bird/configuration.nix
            inputs.hyprland.nixosModules.default
            { programs.hyprland.enable = true; }
          ];
        };
      nixosConfigurations.edgeless-safety-cube =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib; inherit inputs backgroundImg; };
          modules = modulesList ++ [
            disko.nixosModules.disko
            ./hosts/edgeless-safety-cube/configuration.nix
            inputs.hyprland.nixosModules.default
          ];
        };

      homeConfigurations.jabbi = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.base16.homeManagerModule
          ./hm-imports/nvim/neovim.nix
          ./hm-imports/i3.nix
          ./hm-imports/zsh.nix
          ./hm-imports/cli.nix
          ./hm-imports/autorandr.nix
          ./hm-imports/polybar.nix
          {
            home.stateVersion = "22.05";
            home.username = "jabbi";
            home.homeDirectory = "/home/jabbi";
            #scheme = "${inputs.theme}/woodland.yaml";
          }
        ];
        extraSpecialArgs = {
          #scheme = "${inputs.theme}/woodland.yaml";
          inherit inputs;
        };
        #homeDirectory = "/home/jabbi";
        #username = "jabbi";
      };

      deploy = {
        remoteBuild = false;
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
            hostname = "10.0.0.70";
            sshUser = "root";
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."GLaDOS";
              magicRollback = false;
              sshOpts = [ "-o" "StrictHostKeyChecking=no" ];
            };
          };
          "the-bird" = {
            hostname = "10.0.0.61";
            sshUser = "root";
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."the-bird";
              magicRollback = false;
              sshOpts = [ "-o" "StrictHostKeyChecking=no" ];
            };
          };
          "edgeless-safety-cube" = {
            hostname = "webfoo.de";
            sshUser = "root";
            remoteBuild = true;
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."edgeless-safety-cube";
              magicRollback = false;
            };
          };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [
          pkgs.lefthook
          pkgs.nixpkgs-fmt
          #agenix.nixosModules.default
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
          function deployBird() {
            nix run --show-trace github:serokell/deploy-rs .#the-bird
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
            agenix.packages.x86_64-linux.default
          ];
        };
      });
}
