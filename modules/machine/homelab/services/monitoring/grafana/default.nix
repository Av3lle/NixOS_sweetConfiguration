{
    config,
    lib,
    ...
}:
let   
    name = "grafana";
    
    cfgH = config.module.homelab;
    cfg = cfgH.monitoring.${name};
in
with lib; {
    options.module.homelab.monitoring.${name} = {
        enable = mkEnableOption "Enable module";

        port = mkOption {
            description = "port";
            type = types.port;
            default = 3001;
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
            provision.enable = true;
            settings.server.http_port = cfg.port;
        };
    };
}

