{ lib, config, home-manager, pkgs, inputs, ... }:
with lib;
with lib.my;
let
  cfg = config.jabbi.home;
  hmConfig = { pkgs, inputs, config, ... }: {
    # imports = lib.my.mapModulesRec' ../../hm-imports (x: x);
    imports = [
      "${inputs.impermanence}/home-manager.nix"
      ../../hm-imports/nvim/neovim.nix
      ../../hm-imports/i3.nix
      ../../hm-imports/zsh.nix
      ../../hm-imports/cli.nix
      ../../hm-imports/programs.nix
      ../../hm-imports/programs/alacritty.nix
      ../../hm-imports/programs/rofi.nix
      ../../hm-imports/impermanence.nix
    ];
  };
in
{
  options.jabbi.home = {
    enable = mkEnableOption "Enable Homemanager";
  };
  config = mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.jabbi = hmConfig;
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
