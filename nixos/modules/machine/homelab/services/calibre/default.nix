{
    config,
    lib,
    ...
}:
let    
    name = "calibre";
    cfgH = config.module.homelab;
    svc = (cfgH.services or {}).${name} or { enable = false; };
in
lib.mkIf svc.enable {
    virtualisation.oci-containers.containers = {
        calibre = {
            image = "linuxserver/calibre:latest";
            autoStart = true;
            ports = [
                "127.0.0.1:${toString svc.port}:8080" # WebUI
                "0.0.0.0:${toString (svc.port + 1)}:9090" # Server
            ];

            environment = {
                PUID="1000";
                PGID="1000";
                TZ = "Europe/Moscow";
            };

            extraOptions = [
                "--shm-size=1gb"
            ];
            
            volumes = [
                "/var/lib/calibre-docker/config:/config"
                svc.mediaLocation
            ];
        };
    };
}
