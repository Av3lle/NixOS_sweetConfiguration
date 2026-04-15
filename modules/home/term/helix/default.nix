{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "helix";
  cfg = config.module.${name};
in
with lib; {
  options.module.${name} = {
    enable = mkEnableOption "Enable module";
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = "hx";
      };
      packages = with pkgs; [
        nil
        alejandra
        vscode-langservers-extracted
      ];
    };
    programs.helix = {
      enable = true;
      package = pkgs.evil-helix;

      themes.stylix = {
        "ui.background" = {
          bg = config.stylix.colors.base00;
        };
      };
      settings = {
        theme = "stylix";
        editor = {
          line-number = "relative";
          scrolloff = 5;
          mouse = true;
          auto-completion= true;
          auto-format = true;
          idle-timeout = 50;
          cursor-shape = {
            insert = "block";
            normal = "block";
            select = "underline";
          };
          file-picker.hidden = false;
          statusline = {
            left = [
              "mode"
              "spinner"
            ];
            center = [
              "read-only-indicator"
              "file-name"
              "file-modification-indicator"
            ];
            right = [
              "position"
              "register"
              "file-line-ending"
              "file-type"
            ];
            separator = "│";
            mode.normal = "NORMAL";
            mode.insert = "";
            mode.select = "SELECT";
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
        };
        keys = {
          normal = {
            
            "C-s" = ":w";
            "C-q" = ":q";
            "C-A-q" = ":q!";
            "C-k" = "page_down";
            "C-l" = "page_up";

            "j" = "move_char_left";
            "k" = "move_line_down";
            "l" ="move_line_up";
            ";" = "move_char_right";

            g = {
              "k" = "move_line_down";
              "l" = "move_line_up";
            };
          };

          insert = {
            "A-x" = "normal_mode";
          };

          select = {
            "j" = "extend_char_left";
            "k" = "extend_visual_line_down";
            "l" = "extend_visual_line_up";
            ";" = "extend_char_right";
          };
        };
      };

      languages = {
        language-server.typescript-language-server = with pkgs.nodePackages; {
          command = "${typescript-language-server}/bin/typescript-language-server";
          args = [
            "--stdio"
            "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"
          ];
        };
        nil = {
          command = "nil";
          config.nil = {
            formatting.command = [
              "alejandra"
              "-q"
            ];
            nix.flake.autoEvalInputs = true;
          };
        };
        vscode-html-language-server = {
          command = "vscode-html-language-server";
          args = [ "--stdio" ];
        };
        vscode-css-language-server = {
          command = "vscode-css-language-server";
          args = [ "--stdio" ];
        };
        language = [
          {
            name = "nix";
            auto-format = false;
            file-types = [ "nix" ];
          }
        ];
      };
    };
  };
}
