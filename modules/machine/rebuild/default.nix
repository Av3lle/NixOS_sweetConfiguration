{
    lib,
    config,
    self,
    pkgs,
    paths,
    machine,
    systemConfig,
    ...
}:
let
    name = "rebuild";
    cfg = config.module.${name};
in
with lib; {

    # find . -type f -not -path '*/\.git/*' -exec chmod 644 {} +
    # find . -type d -exec chmod 755 {} +
    
    options.module.${name} = {
        enable = mkEnableOption "Enables custom rebuild script";

        nhEnable = mkOption {
            description = "nh Enable";
            type = types.bool;
            default = false;
        };
    };

    config = mkIf cfg.enable {
        programs.nh = {
            enable = cfg.nhEnable;
            flake = paths.flakeDir;
        };
        environment.systemPackages = with pkgs; [
            (pkgs.writeShellScriptBin "rebuild" ''
                #!/bin/sh

                notify() {
                    status="$1"
                    message="$2"
                    
                    case "$status" in
                        success)
                            ${pkgs.libnotify}/bin/notify-send "❄️ Nix rebuild" "$message" -i dialog-information -u normal
                            ;;
                        error)
                            ${pkgs.libnotify}/bin/notify-send "❄️ Nix rebuild" "$message" -i dialog-error -u critical
                            ;;
                    esac
                }

                run_with_notify() {
                    title="$1"
                    shift

                    if "$@"; then
                        notify success "✅ $title completed successfully"
                    else
                        notify error "❌ $title failed"
                        return 1
                    fi
                }
                
                git_commit() {
                    git --git-dir="${paths.flakeDir}/.git" --work-tree="${paths.flakeDir}" add .
                    git --git-dir="${paths.flakeDir}/.git" --work-tree="${paths.flakeDir}" commit -m "commit $(date "+%F %H:%M")"
                    git --git-dir="${paths.flakeDir}/.git" push -u origin sweet
                }

                flake() {
                    cp ${paths.flakeDir}/flake.lock ${paths.flakeDir}/flake.lock.bak
                    run_with_notify "Flake update" \
                        doas nix flake update --flake ${paths.flakeDir} 
                }

                ${if cfg.nhEnable then
                ''
                    nixos() {
                        run_with_notify "NixOS rebuild" \
                            nh os switch -t --hostname ${machine}
                    }
                ''
                else ''
                    nixos() {
                        nix_boot=$(readlink -f /run/current-system)

                        if doas nixos-rebuild switch --show-trace \
                            --flake ${paths.flakeDir}#${machine} --upgrade 2>&1 |& nom; then
                                nix_now=$(readlink -f /nix/var/nix/profiles/system)
                                nvd diff "$nix_boot" "$nix_now"
                                notify success "NixOS rebuild completed successfully"
                        else
                            notify error "NixOS rebuild failed"
                            return 1
                        fi
                    }
                ''}

                ${if cfg.nhEnable then
                ''
                    home_manager() {
                        run_with_notify "Home Manager rebuild" \
                            nh home switch -t -b bak -c ${machine}
                    }
                ''
                else ''
                    home_manager() {
                        profiles=$(readlink -f /home/${systemConfig.userName}/.local/state/nix/profiles/profile)
                        hm_boot=$profiles

                        if home-manager switch --show-trace \
                            --flake ${paths.flakeDir}#${machine} 2>&1 |& nom; then
                            hm_now=$profiles
                            nvd diff "$hm_boot" "$hm_now"
                            notify success "Home Manager rebuild completed successfully"
                        else
                            notify error "Home Manager rebuild failed"
                            return 1
                        fi
                    }
                ''}
                
                clear() {
                    nix-env --delete-generations +2 && \
                    home-manager expire-generations +2 generations && \
                    nix-collect-garbage -d
                }

                if [ -d "${self}" ]; then
                    case "$1" in
                        git) git_commit ;;
                        flake) flake ;;
                        nix) nixos ;;
                        hm) home_manager ;;
                        clear) clear ;;
                        *)
                            if flake &&
                                git_commit &&
                                nixos &&
                                home_manager &&
                                clear;
                            then
                                notify success "Full rebuild completed successfully" dialog-ok
                            else
                                notify error "Rebuild stopped due to error" dialog-error
                            fi
                        ;;
                    esac
                else
                    echo "
                        This directory could not be found.
                        Please check that the path to the directory is correct in the ${paths.flakeDir}/configuration.nix file."
                fi
            '')
            nix-output-monitor nvd
        ];   
    };
}
