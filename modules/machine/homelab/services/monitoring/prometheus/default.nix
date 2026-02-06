{
    config,
    lib,
    ...
}:
let
    name = "prometheus";

    cfgH = config.module.homelab;
    cfg = cfgH.monitoring.${name};
in
with lib; {
    options.module.homelab.monitoring.${name} = {
        enable = mkEnableOption "Enable module";

        port = mkOption {
            description = "port";
            type = types.port;
            default = 9999;
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

        hardware.sensor.hddtemp = {
            enable = true;
            drives = [ "/dev/disk/by-partuuid/*" ];
        };

        services.prometheus = {
            enable = true;
            port = cfg.port;
            scrapeConfigs = [
                {
                    job_name = "node";
                    static_configs = [
                        { targets = [ "localhost:9998" ]; }
                    ];
                }
                {
                    job_name = "smartctl";
                    static_configs = [
                        { targets = [ "localhost:9997" ]; }
                        { targets = [ "192.168.1.100:9997" ]; }
                    ];
                }
            ];
            exporters = {
                node = {
                    enable = true;
                    port = 9998;
                    enabledCollectors = [
                        "cpu"
                        "diskstats"
                        "filesystem"
                        "meminfo"
                        "loadavg"
                        "thermal_zone"
                        "interrupts"
                        "netdev"
                    ];
                };
                smartctl = {
                    enable = true;
                    port = 9997;
                    maxInterval = "360m";
                };
            };
        };
    };    
}
