{ pkgs, config, inputs, ... }:
{
  home.packages = [
    pkgs.nodejs
  ];
  home.file.".config/nvim".source = ./config;
  home.file.".config/nvim".recursive = true;
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;

    plugins = with pkgs.vimPlugins; [
      galaxyline-nvim
      barbar-nvim
      coc-nvim
      telescope-nvim
      toggleterm-nvim
      vim-nix
    ];
  };
}
