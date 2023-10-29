{ pkgs, config, inputs, scheme, ... }:
{
  home.packages = with pkgs; [
    nodejs
    lazygit
    jdk
    # Livesearch
    ripgrep
    # Clipboard
    xclip
    # clangd
    clang-tools
    ltex-ls
    nil
    rnix-lsp
  ];

  home.file.".config/nvim".source = ./config;
  home.file.".config/nvim".recursive = true;
  home.file.".config/nvim/coc-settings.json".text = '' 
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
  "svelte.plugin.typescript.enable": "true",
  "html.autoClosingTags": true,
  "explorer.icon.enableNerdfont": true,
  "java.format.enabled": true,
  "java.format.onType.enabled": true,
  "python.linting.mypyEnabled": true,
  "python.linting.flake8Enabled": true,
  "python.formatting.provider": "black",
  "pydocstring.formatter": "numpy",
  "typescript.preferences.importModuleSpecifier": "relative",
  "eslint.trace.server": "verbose",
  "tailwindCSS.includeLanguages": ["html", "svelte"],
  "eslint.execArgv": ["--max_old_space_size=8192"],
  "languageserver": {
    "golang": {
      "command": "gopls",
      "rootPatterns": ["go.mod", ".vim/", ".git/", ".hg/"],
      "filetypes": ["go"],
      "initializationOptions": {
        "usePlaceholders": true
      }
    },
    "nix": {
      "command": "nil",
      "filetypes": ["nix"],
      "rootPatterns":  ["flake.nix"],
      "settings": {
        "nil": {
          "formatting": { "command": ["nixpkgs-fmt"] }
        }
      }
    }
  },
  "coc.preferences.extensionUpdateCheck": "daily",
  "clangd.path": "${pkgs.clang-tools}/bin/clangd",
  "outline": {
    "sortBy": "position"
  },
  
  "explorer.width": 80,
  "flutter.sdk.path": "${pkgs.flutter}",
  "coc.source.vimtex.filetypes": ["tex", "latex", "markdown", "md"]
}
    '';
    ##"ltex.ltex-ls.path": "${pkgs.ltex-ls}",
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    extraConfig = ''
      set runtimepath^=~/.config/nvim
      lua dofile('${./config/init.lua}')
    '';

    plugins =
      let
        jesterVIM = pkgs.vimUtils.buildVimPlugin {
          name = "jester";
          src = pkgs.fetchFromGitHub {
            owner = "David-Kunz";
            repo = "jester";
            rev = "3065b2139c4cc26b4cea1bdab98016c60b4f48de";
            sha256 = "sha256-7bw7Y3KrvCmLpuLfLfUhpUXwpHAZE1kifG2IA1lRO1s=";
          };
        };
      in
      with pkgs.vimPlugins; [
        #galaxyline-nvim
        jesterVIM
        barbar-nvim
        nvim-web-devicons
        coc-nvim
        coc-svelte
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
        coc-java
        #coc-angular 
        coc-lua
        coc-explorer
        coc-clangd
        coc-rust-analyzer
        lualine-nvim
        coc-vimtex
        coc-ltex
        vimtex
        vimspector
        nvim-treesitter-context
        nvim-treesitter.withAllGrammars
        (base16-vim.overrideAttrs (old:
          let
            schemeFile = config.scheme inputs.base16-vim;
          in
          {
            patchPhase = builtins.trace schemeFile ''
              cp ${schemeFile} colors/base16-scheme.vim
            '';
          }))
      ];
  };
}
