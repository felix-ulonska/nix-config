{ pkgs, config, inputs, scheme, ... }:
{
  home.packages = [
    pkgs.nodejs
    pkgs.lazygit
    pkgs.jdk

    # Livesearch
    pkgs.ripgrep

    # Clipboard
    pkgs.xclip
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
      #galaxyline-nvim
      barbar-nvim
      nvim-web-devicons
      coc-nvim
      telescope-nvim
      telescope-coc-nvim
      vim-sleuth
      toggleterm-nvim
      vim-nix
      gitsigns-nvim
      hop-nvim
      vim-fugitive
      coc-tsserver
      coc-pairs
      coc-html
      coc-css
      coc-eslint
      coc-prettier
      coc-json
      # coc-angular 
      coc-lua
      coc-explorer
      coc-clangd
      coc-rust-analyzer
      #coc-flutter-tools
      lualine-nvim
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
