{
    lib,
    config,
    pkgs,
    pathsConfig,
    ...
}:
let
    name = "gitPush";
    cfg = config.module.customBin.${name};

    publicPath = "${pathsConfig.flakeDir}/../nixos_github";
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
                        ${pathsConfig.flakeDir}/ ${publicPath}/
                    git --git-dir="${publicPath}/.git" --work-tree="${publicPath}" add .
                    git --git-dir="${publicPath}/.git" --work-tree="${publicPath}" commit -m "commit $(date "+%F %H:%M")"
                    git --git-dir="${publicPath}/.git" push -u origin sweet
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
