{ config, lib, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) port;
    
    name = "vaultwarden";
    cfgH = config.module.homelab;
    cfg = cfgH.${name};
in {
    options.module.homelab.${name} = {
        enable = mkEnableOption "Enable module";

        port = mkOption {
            description = "port?";
            type = port;
            default = 8222;
        };
    };

    config = mkIf cfg.enable {
        services.nginx = {
            virtualHosts."${name}.${cfgH.domain}" = {
                locations."/" = {
                    proxyPass = "http://127.0.0.1:${toString cfg.port}";
                    proxyWebsockets = true;
                };
            } // cfgH.sslCert;
        };

        services.${name} = {
            enable = true;
            dbBackend = "sqlite";
            environmentFile = "/var/lib/${name}/.env";
            config = {
                ROCKET_ADDRESS = "127.0.0.1";
                ROCKET_PORT = cfg.port;
                SIGNUPS_ALLOWED = false;
            };
        }; 
    };
}
