{
    lib,
    config,
    self,
    pkgs,
    pathsConfig,
    ...
}:
let
    name = "gitPush";
    cfg = config.module.customBin.${name};
in
with lib; {
    options.module.customBin.${name} = {
        enable = mkEnableOption "Enables custom git push script";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [
            (pkgs.writeShellScriptBin "_git" ''
                #!/bin/sh
                
                git_commit_private() {
                    git --git-dir="${pathsConfig.flakeDir}/.git" --work-tree="${pathsConfig.flakeDir}" add .
                    git --git-dir="${pathsConfig.flakeDir}/.git" --work-tree="${pathsConfig.flakeDir}" commit -m "commit $(date "+%F %H:%M")"
                    git --git-dir="${pathsConfig.flakeDir}/.git" push -u origin sweet
                }

                git_commit_public() {
                    rsync -a --delete \
                        --exclude='.git' \
                        --exclude='.gitignore' \
                        --exclude='flake.lock.bak' \
                        ${pathsConfig.flakeDir}/ ${pathsConfig.flakeDir}/../nixos_github/
                    git --git-dir="${pathsConfig.flakeDir}/../nixos_github/.git" --work-tree="${pathsConfig.flakeDir}/../nixos_github" add .
                    git --git-dir="${pathsConfig.flakeDir}/../nixos_github/.git" --work-tree="${pathsConfig.flakeDir}/../nixos_github" commit -m "commit $(date "+%F %H:%M")"
                    git --git-dir="${pathsConfig.flakeDir}/../nixos_github/.git" push -u origin sweet
                }

                case "$1" in
                    private) git_commit_private ;;
                    public) git_commit_public ;;
                    all) git_commit_private && git_commit_public ;;
                    *)
                        if
                            git_commit_private;
                        then
                            :
                        fi
                    ;;
                esac
            '')
        ];   
    };
}
