{ config, lib, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "helix";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            nil
            alejandra
            vscode-langservers-extracted
        ];
        programs.helix = {
            enable = true;

            themes.stylix = {
                "ui.background" = { bg = config.stylix.colors.base00; };
            };
            settings = {
                theme = "stylix";
                editor = {
                    line-number = "absolute";
                    scrolloff = 5;
                    mouse = true;
                    auto-completion = true;
                    auto-format = true;
                    idle-timeout = 0;
                    cursor-shape = {
                        insert = "block";
                        normal = "block";
                        select = "underline";
                    };
                    file-picker.hidden = false;
                    statusline = {
                        left = ["mode" "spinner"];
                        center = ["file-name" "file-modification-indicator"];
                        right = ["register" "file-line-ending" "file-type"];
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
                        "C-j" = "page_down";
                        "C-k" = "page_up";
                    };
                };
            };
  
            languages = {
                language-server.typescript-language-server = with pkgs.nodePackages; {
                    command = "${typescript-language-server}/bin/typescript-language-server";
                    args = [ "--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib" ];
                };
                nil = {
                    command = "nil";
                    config.nil = {
                        formatting.command = [ "alejandra" "-q" ];
                        nix.flake.autoEvalInputs = true;
                    };
                };
                vscode-html-language-server = {
                    command = "vscode-html-language-server";
                    args = ["--stdio"];
                };
                vscode-css-language-server = {
                    command = "vscode-css-language-server";
                    args = ["--stdio"];
                };
                language = [{
                    name = "nix";
                    auto-format = true;
                    file-types = [ "nix" ];
                }];
            };
        };
    };
}
