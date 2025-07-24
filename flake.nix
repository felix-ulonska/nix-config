{
  description = "An example NixOS configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-25.05"; };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
    };
    agenix.url = "github:ryantm/agenix";
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    impermanence.url = "github:nix-community/impermanence";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    base16.url = "github:SenchoPens/base16.nix/def69d6edc32792562975aec863dbef757f832cf";
    base16.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/c1cfbfad7cb45f0c177b35b59ba67d1b5fc7ca82";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    itpms-site.url = "gitlab:itpms/website";

    felixnixvim.url = "github:felix-ulonska/vim";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #stylix.url = "github:nix-community/stylix/release-25.05";
    stylix.url = "github:nix-community/stylix/7a0f30b57eb940cd280e2001c73b09a63e6a5311";


    #hyprland = {
    #  url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    #};
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    background = {
      url = "https://i.redd.it/yuxe7ow1wyy91.png"; # Sanfransico
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
      #url = "github:PandorasFox/base16-pandora-scheme";
      url = "github:tinted-theming/base16-schemes";
      #url = "github:chawyehsu/base16-snazzy-scheme";
      #url = github:kjakapat/base16-eva-scheme;
      #url = "github:catppuccin/base16";
      flake = false;
    };

    base16-zathura = {
      url = "github:haozeke/base16-zathura";
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ { self, nixpkgs, deploy-rs, agenix, simple-nixos-mailserver, home-manager, base16, nur, impermanence, flake-utils, stylix, background, nixos-hardware, felixnixvim, disko, lix-module, zen-browser, comin, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs; lib = self; };
      });
      #backgroundImg = background;
      modulesList = lib.flatten [
        agenix.nixosModules.default
        simple-nixos-mailserver.nixosModule
        #lix-module.nixosModules.default
        base16.nixosModule
        { scheme = "${inputs.theme}/humanoid-dark.yaml"; }
        #{ scheme = "${inputs.theme}/oxocarbon-light.yaml"; }
        #{ scheme = "${inputs.theme}/atelier-heath-light.yaml"; }
        #{ scheme = ./assets/summerfruit-light.yaml; }
        #{ scheme = "${inputs.theme}/windows-95-light.yaml"; }
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        (lib.my.mapModulesRec' (toString ./modules) import)
      ];
    in
    {
      lib = lib.my;
      nixosModules = lib.my.mapModulesRec ./modules/services import;
      outputFoo = modulesList ++ [ ./hosts/silbervogel/configuration.nix ];

      nixosConfigurations.GLaDOS =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib inputs; };
          modules = modulesList ++ [
            ./hosts/glados/configuration.nix
            nixos-hardware.nixosModules.lenovo-legion-16ach6h
            #inputs.hyprland.nixosModules.default
            { programs.hyprland.enable = true; }
          ];
        };
      nixosConfigurations.the-bird =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib inputs; };
          modules = modulesList ++ [
            ./hosts/the-bird/configuration.nix
            #inputs.hyprland.nixosModules.default
            { programs.hyprland.enable = true; }
          ];
        };
      nixosConfigurations.edgeless-safety-cube =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib inputs; };
          modules = modulesList ++ [
            disko.nixosModules.disko
            ./hosts/edgeless-safety-cube/configuration.nix
            #inputs.hyprland.nixosModules.default
          ];
        };
      nixosConfigurations.cave =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit lib inputs; };
          modules = modulesList ++ [
            ./hosts/cave/configuration.nix
            comin.nixosModules.comin
            #inputs.hyprland.nixosModules.default
          ];
        };

      deploy = {
        remoteBuild = false;
        nodes = {
          "GLaDOS" = {
            hostname = "10.0.0.64";
            sshUser = "root";
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."GLaDOS";
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
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in
      {

        devShells.default = pkgs.mkShell {
          buildInputs = [
            agenix.packages.x86_64-linux.default
          ];
        };
      });
}
