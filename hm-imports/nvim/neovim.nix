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
  home.file.".config/nvim/coc-settings.json".text ='' 
{
  "coc.preferences.formatOnSaveFiletypes": [
    "scss",
    "golang",
    "go",
    "html",
    "typescript",
    "dart",
    "python"
  ],
  "Lua.diagnostics.globals": ["vim"],
  "html.enable": true,
  "ltex.enabled": true,
  "ltex.language": "de-DE",
  "html.autoClosingTags": true,
  "explorer.icon.enableNerdfont": true,
  "python.linting.mypyEnabled": true,
  "python.linting.flake8Enabled": true,
  "python.formatting.provider": "black",
  "pydocstring.formatter": "numpy",
  "languageserver": {
    "golang": {
      "command": "gopls",
      "rootPatterns": ["go.mod", ".vim/", ".git/", ".hg/"],
      "filetypes": ["go"],
      "initializationOptions": {
        "usePlaceholders": true
      }
    },
    "haskell": {
      "command": "haskell-language-server-wrapper",
      "args": ["--lsp"],
      "rootPatterns": [
        "*.cabal",
        "stack.yaml",
        "cabal.project",
        "package.yaml",
        "hie.yaml"
      ],
      "filetypes": ["haskell", "lhaskell"]
    },
    "graphql": {
      "command": "graphql-lsp",
      "args": ["server", "-m", "stream"],
      "filetypes": ["typescript", "typescriptreact", "graphql"]
    }
  },
  "coc.preferences.extensionUpdateCheck": "daily",
  "clangd.path": "~/.config/coc/extensions/coc-clangd-data/install/13.0.0/clangd_13.0.0/bin/clangd",
  "outline": {
    "sortBy": "position"
  },
  "explorer.width": 80,
  "flutter.sdk.path": "${pkgs.flutter}"
}
    '';
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
      #coc-flutter
      dart-vim-plugin
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
