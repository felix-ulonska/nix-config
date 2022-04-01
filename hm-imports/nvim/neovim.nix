{ pkgs, config, inputs, scheme, ... }:
{
  home.packages = [
    pkgs.nodejs
    pkgs.lazygit
    pkgs.jdk
  ];
  home.file.".config/nvim".source = ./config;
  home.file.".config/nvim".recursive = true;
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    extraConfig = ''
      set runtimepath^=~/.config/nvim
      lua dofile('${./config/init.lua}')
    '';

    plugins = with pkgs.vimPlugins; [
      galaxyline-nvim
      barbar-nvim
      nvim-web-devicons
      coc-nvim
      telescope-nvim
      toggleterm-nvim
      vim-nix
      coc-tsserver
      coc-pairs
      coc-html
      coc-css
      coc-eslint
      coc-prettier
      coc-json
      # coc-angular -- TODO add coc-angular
      coc-lua
      coc-explorer
      coc-clangd
      #coc-flutter-tools
      (base16-vim.overrideAttrs (old:
        let
          schemeFile = scheme inputs.base16-vim;
        in
        {
          patchPhase = builtins.trace schemeFile ''
            cp ${schemeFile} colors/base16-scheme.vim
          '';
        }))
    ];
  };
}
