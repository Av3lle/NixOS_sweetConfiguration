{ config, lib, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) port str;
    
    name = "immich";
    cfgH = config.module.homelab;
    cfg = cfgH.${name};
in {
    options.module.homelab.${name} = {
        enable = mkEnableOption "Enable module";

        port = mkOption {
            description = "port";
            type = port;
            default = 2283;
        };

        mediaLocation = mkOption {
            description = "location";
            type = str;
            default = "/srv/immich";
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
            host = "127.0.0.1";
            port = cfg.port;
            mediaLocation = cfg.mediaLocation;
        };
    };
}
