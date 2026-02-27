{
    config,
    lib,
    ...
}:
let
    name = "prometheus";
    cfgH = config.module.homelab;
    svc = (cfgH.services or {}).${name} or { enable = false; };
in
lib.mkIf svc.enable {
    hardware.sensor.hddtemp = {
        enable = true;
        drives = [ "/dev/disk/by-partuuid/*" ];
    };

    services.${name}= {
        enable = true;
        port = svc.port or 9999;
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
}
