{ lib, config, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) bool str port enum;

    name = "ssh";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enables ssh";

        ports = mkOption {
            description = "Port?";
            type = port;
            default = 22;
        };

        only-client = mkOption {
            description = "It makes it so that no one can connect";
            type = bool;
            default = true;  
        };

        rootLogin = mkOption {
            description = "Allow root login via SSH";
            type = enum ["no" "prohibit-password" "yes"];
            default = "no";
        };

        fail2ban = {
            enable = mkOption {
                description = "Enable fail2ban for SSH protection";
                type = bool;
                default = false;
            };

            ignoreIP = mkOption {
                description = "Ignore ip";
                type = str;
                default = "192.168.1.0/24";
            };
        };
    };

    config = mkIf cfg.enable {
        services = {
        openssh = {
            enable = true;
            ports = [ cfg.ports ];
            settings = {
                    PasswordAuthentication = if cfg.only-client then false else true;
                    PermitRootLogin = cfg.rootLogin;
            };
        };
        fail2ban = mkIf cfg.fail2ban.enable {
            enable = true;
            maxretry = 5;
            ignoreIP = [ cfg.fail2ban.ignoreIP ];
            bantime = "24h";
            bantime-increment = {
                enable = true;
                #formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
                multipliers = "1 2 4 8 16 32 64";
                maxtime = "168h";
                overalljails = true;
            };
        };
        }; 
    };
}
