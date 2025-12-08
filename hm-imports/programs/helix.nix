{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      keys.insert = { j = { k = "normal_mode"; }; };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
      {
        name = "c-sharp";
        auto-format = true;
        formatter.command = "dotnet";
        formatter.args = [ "csharpier" "format" ];
        #language-servers = [ "roslyn" ];
      }
      {
        name = "hcl";
        file-types = [ "tofu" ];
      }
      {
        name = "markdown";
        file-types = [ "md" "mdx" ];
        language-servers = [ "ltex" "marksman" ];
      }
    ];
    languages.language-server = {
      roslyn = {
        command = "Microsoft.CodeAnalysis.LanguageServer";
        args = [
          "--stdio"
          "--logLevel"
          "Error"
          "--extensionLogDirectory"
          "/tmp/foo"
        ];
      };
      ltex = { command = "${pkgs.ltex-ls-plus}/bin/ltex-ls-plus"; };
    };
    extraPackages = with pkgs; [
      omnisharp-roslyn
      #roslyn-ls
      netcoredbg
      nil
      protols
      rust-analyzer
      typescript-language-server
      ty
      marksman
    ];
  };
  programs.zellij = {
    enable = true;
    extraConfig = ''
      keybinds {
      // keybinds are divided into modes
          unbind "Ctrl o"
      normal {
          // bind instructions can include one or more keys (both keys will be bound separately)
          // bind keys can include one or more actions (all actions will be performed with no sequential guarantees)
          bind "Ctrl g" { 
              Run "lazygit"  {
                close_on_exit true
              };
              TogglePaneEmbedOrFloating;
              SwitchToMode "normal";
          }
        }
      }
    '';
  };
}
