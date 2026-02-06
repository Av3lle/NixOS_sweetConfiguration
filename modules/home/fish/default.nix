{
    config,
    lib,
    pathsConfig,
    
    ...
}:
let
    name = "fish";
    cfg = config.module.${name};
in
with lib; {
    options.module.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        programs.fish = {
            enable = true;
            interactiveShellInit = "
                set -g fish_greeting
            ";
            shellAliases = {
                sudo = "doas";
            };
            functions = {
                conf = ''
                    if test -d "${pathsConfig.flakeDir}"
                        cd "${pathsConfig.flakeDir}"
                    else
                        echo "Directory not found: ${pathsConfig.flakeDir}"
                    end
                '';
            };
        };

        programs.tmux = {
            enable = true;

            terminal = "screen-256color";

            baseIndex = 1;
            keyMode = "vi";
            prefix = "C-a";

            extraConfig = "
                unbind r
                bind r source-file ${config.home.homeDirectory}/.config/tmux/tmux.conf

                unbind %
                bind h split-window -h
                bind v split-window -v
                
            ";
        };

        programs.starship = {
            enable = true;
            settings = {
                add_newline = false;
                
                format = ''
                    [╭─ ](bold) $username[@](bold)$hostname$kubernetes$directory$git_branch$git_commit$git_state$git_status$docker_context$package$golang$helm$java$cmake$julia$kotlin$lua$nim$nodejs$python$ruby$rust$swift$terraform$aws$gcloud$azure$nix_shell$fill$character$cmd_duration$time
                    [╰──> ](bold)
                '';
        
                fill.symbol = " ";
                
                character = {
                    error_symbol = "[](bold red)";
                    success_symbol = "[](bold green)";
                    vimcmd_symbol = "[N](bold blue)";
                    vimcmd_visual_symbol = "[V](bold red)";
                    vimcmd_replace_one_symbol = "[R](bold purple)";
                    vimcmd_replace_symbol = "[R](bold purple)";
                };

                username = {
                    format = "[$user]($style)";
                    style_user = "white";
                    disabled = false;
                    show_always = true;
                };

                hostname = {
                    ssh_only = false;
                    format = "[$hostname]($style) ";
                    style = "gray";
                    trim_at = ".";
                    disabled = false;
                };

                nix_shell = {
                    symbol = " ";
                };

                golang = {
                    style = "blue";
                    symbol = " ";
                };

                lua = {
                    symbol = " ";
                };

                cmake = {
                    style = "green";
                    symbol = "△ ";
                };

                git_branch = {
                    symbol = "($style) ";
                    style = "#D6B89C";
                    
                };
                
                rust = {
                    symbol = " ";
                };
                
                nodejs = {
                    symbol = " ";
                };

                docker_context = {
                    symbol = " ";
                };

                time = {
                    format = "[$time]($style) ";
                    style = "bold";
                    disabled = false;
                };

                cmd_duration = {
                    format = "[$duration]($style) ";
                    style = "bold white";
                };

                status = {
                    format = "[$symbol]($style) ";
                    symbol = "[](bold red)";
                    success_symbol = "[](bold green)";
                    disabled = false;
                };

                directory = {
                    read_only = " ";
                    truncation_length = 7;
                    truncation_symbol = "… /";
                    style = "white";
                };
            };
        };
    };
}
