{
    config,
    lib,
    ...
}:
let    
    name = "calibre";
    cfgH = config.module.homelab;
    cfg = cfgH.${name};
in
with lib; {
    options.module.homelab.${name} = {
        enable = mkEnableOption "Enable module";

        port = mkOption {
            description = "port";
            type = types.port;
            default = 3004;
        };
    };

    config = mkIf cfg.enable {
        services.nginx = {
            virtualHosts."calibre.${cfgH.domain}" = {
                locations."/" = {
                    proxyPass = "http://127.0.0.1:${toString cfg.port}";
                    proxyWebsockets = true;
                };
            } // cfgH.sslCert;
        };

        # networking.firewall = {
            # allowedUDPPorts = [ "${toString (cfg.port + 1)}" ];
            # allowedTCPPorts = [ "${toString (cfg.port + 1)}" ];
        # };
        virtualisation.oci-containers.containers = {
            calibre = {
                image = "linuxserver/calibre:latest";
                autoStart = true;
                ports = [
                    "127.0.0.1:${toString cfg.port}:8080" # WebUI
                    "0.0.0.0:${toString (cfg.port + 1)}:9090" # Server
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
                    "/mnt/files/nfs/ebooks:/config/ebooks"
                ];
            };
        };
    };
}
