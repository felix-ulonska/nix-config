{ lib, config, home-manager, pkgs, inputs, backgroundImg, ... }:
with lib;
with lib.my;
let
  cfg = config.jabbi.home;
  baseImports = [
    "${inputs.impermanence}/home-manager.nix"
    inputs.base16.homeManagerModule
    inputs.felixnixvim.homeManagerModules.default
    ../../hm-imports/i3.nix
    ../../hm-imports/zsh.nix
    ../../hm-imports/cli.nix
    ../../hm-imports/autorandr.nix
    ../../hm-imports/polybar.nix
    ../../hm-imports/nixvim.nix
    {
    stylix.targets.kde.enable = false;
    # Just broken, I do not use that tool?!
    stylix.targets.bemenu.enable = false;
    }
  ];
  visualImports = [
    ../../hm-imports/programs.nix
    ../../hm-imports/programs/alacritty.nix
    ../../hm-imports/programs/zathura.nix
    ../../hm-imports/programs/rofi.nix
    ../../hm-imports/hyprland.nix
  ];
in
{
  options.jabbi.home = {
    enable = mkEnableOption "Enable Homemanager";
    enableVisualApps = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    impermanence = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    userName = lib.mkOption {
      type = lib.types.str;
      default = "jabbi";
    };
  };
  config = mkIf cfg.enable {
    #home-manager.useGlobalPkgs = true;
    #home-manager.useUserPackages = true;
    home-manager.users."${cfg.userName}" = {
      home.stateVersion = "22.05";
      imports = baseImports ++ optionals cfg.enableVisualApps visualImports ++ optional cfg.impermanence ../../hm-imports/impermanence.nix;
      nixpkgs.config.allowUnfree = true;
    };

    #home-manager.extraSpecialArgs = { config.scheme = config.scheme; config.targets.darwin = {search = null; keybindings = null; defaults = {}; currentHostDefaults = {};}; inputs = inputs; };
    home-manager.extraSpecialArgs = { inherit (config) scheme; inherit inputs backgroundImg; };

    systemd.services.persistence-folder = {
      script = ''
        mkdir -p /nix/persist/home/jabbi
        chown jabbi /nix/persist/home/jabbi
      '';
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
