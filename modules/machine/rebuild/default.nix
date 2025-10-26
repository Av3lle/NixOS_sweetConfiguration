{ lib, config, self, pkgs, paths, machine, system, ... }: let
    inherit (lib) mkEnableOption mkIf;

    name = "rebuild";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enables custom rebuild script";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            (pkgs.writeShellScriptBin "rebuild" ''
                #!/bin/sh
                
                git_commit() {
                    git --git-dir="${paths.flakeDir}/.git" --work-tree="${paths.flakeDir}" add .
                    git --git-dir="${paths.flakeDir}/.git" --work-tree="${paths.flakeDir}" commit -m "commit $(date "+%F %H:%M")"
                    git --git-dir="${paths.flakeDir}/.git" push -u origin sweet
                }

                flake() {
                    cp ${paths.flakeDir}/flake.lock ${paths.flakeDir}/flake.lock.bak
                    doas nix flake update --flake ${paths.flakeDir} 
                }

                nixos() {
                    nix_boot=$(echo $(readlink -f /run/current-system))
                    doas nixos-rebuild switch --show-trace --flake ${paths.flakeDir}#${machine} --upgrade 2>&1 |& nom &&
                    nix_now=$(echo $(readlink -f /nix/var/nix/profiles/system))
                    nvd diff $nix_boot $nix_now 
                }

                home_manager() {
                    profiles=$(echo $(readlink -f /home/${system.userName}/.local/state/nix/profiles/profile))
                    hm_boot=$profiles
                    home-manager switch --show-trace --flake ${paths.flakeDir}#${machine} 2>&1 |& nom &&
                    hm_now=$profiles
                    nvd diff $hm_boot $hm_now 
                }

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
                            flake && \
                            git_commit && \
                            nixos && \
                            home_manager && \
                            clear
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
