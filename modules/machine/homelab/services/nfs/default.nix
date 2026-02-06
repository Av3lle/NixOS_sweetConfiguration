{ config, lib, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) str;
    
    name = "nfs";
    cfg = config.module.homelab.${name};
in {
    options.module.homelab.${name} = {
        enable = mkEnableOption "Enable module";

        dir = mkOption {
            description = "Choice dir in share";
            type = str;
            default = "";
        };

        ip = mkOption {
            description = "Set ip";
            type = str;
            default = "";
        };
    };

    config = mkIf cfg.enable {
        networking.firewall.allowedTCPPorts = [ 2049 ];

        services.${name}.server = {
            enable = true;
            exports = ''
                ${cfg.dir} ${cfg.ip}(rw,sync,no_subtree_check,wdelay,no_root_squash,all_squash)
            '';
        };
    };
}
