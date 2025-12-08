{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      keys = {
        insert = { j = { k = "normal_mode"; }; };
        normal = {
          q = let
            yazi-picker = pkgs.writeShellApplication {
              name = "yazi-picker";

              text = ''
                #!${pkgs.bash}/bin/bash

                serpl
                exit_code=$?

                if [[ $exit_code -eq 0 ]]; then
                    zellij action toggle-floating-panes
                    zellij action write-chars ":reload-all"
                    zellij action write 13 # send <Enter> key
                fi
              '';
            };
          in {
            q =
              ":sh zellij run -c -f -x 10% -y 10% --width 80% --height 80% -- bash ~/.config/helix/yazi-picker.sh open";
            v =
              ":sh zellij run -c -f -x 10% -y 10% --width 80% --height 80% -- bash ~/.config/helix/yazi-picker.sh vsplit";
            s =
              ":sh zellij run -c -f -x 10% -y 10% --width 80% --height 80% -- bash ~/.config/helix/yazi-picker.sh hsplit";
          };
        };
      };
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
    };
    extraPackages = with pkgs; [
      omnisharp-roslyn
      tofu-ls
      yaml-language-server
      helm-ls
      netcoredbg
      nil
      protols
      rust-analyzer
      typescript-language-server
      ty
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
    #enableNushellIntegration = true;
  };
}
