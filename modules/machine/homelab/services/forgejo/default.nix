{ config, lib, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) port;
    
    name = "forgejo";
    cfgH = config.module.homelab;
    cfg = cfgH.${name};
in {
    options.module.homelab.${name} = {
        enable = mkEnableOption "Enable module";

        port = mkOption {
            description = "port";
            type = port;
            default = 3000;
        };
    };

    config = mkIf cfg.enable {
        services.nginx = {
            virtualHosts."git.${cfgH.domain}" = {
                locations."/" = {
                    proxyPass = "http://127.0.0.1:${toString cfg.port}";
                    proxyWebsockets = true;
                };
            } // cfgH.sslCert;
        };
        services.${name} = {
            enable = true;
            database.type = "postgres";
            lfs.enable = true;
            settings = {
                server = {
                    HTTP_ADDR = "127.0.0.1";
                    HTTP_PORT = cfg.port;
                };
                service.DISABLE_REGISTRATION = true; 
                actions = {
                    ENABLED = true;
                    DEFAULT_ACTIONS_URL = "github";
                };
            };
        };
    };
}
