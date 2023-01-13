{ lib, config, home-manager, pkgs, inputs, ... }:
with lib;
with lib.my;
let
  cfg = config.jabbi.home;
  baseImports = [
    "${inputs.impermanence}/home-manager.nix"
    inputs.base16.homeManagerModule
    ../../hm-imports/nvim/neovim.nix
    ../../hm-imports/i3.nix
    ../../hm-imports/zsh.nix
    ../../hm-imports/cli.nix
    ../../hm-imports/autorandr.nix
    ../../hm-imports/polybar.nix
    ../../hm-imports/gnome.nix
  ];
  visualImports = [
    ../../hm-imports/programs.nix
    ../../hm-imports/programs/alacritty.nix
    ../../hm-imports/programs/zathura.nix
    ../../hm-imports/programs/rofi.nix
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
      type = lib.types.string;
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
    home-manager.extraSpecialArgs = { scheme = config.scheme; inputs = inputs; };

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
