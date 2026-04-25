{
    systemConfig,
    pkgs,
    _imports,
    lib,
    config,
    self,
    ...
}:
{
    imports = [
        ./hardware-configuration.nix
    ] ++ (_imports.allDefaultDir {
        dir = ./system;
    });


    security.pki.certificateFiles = [
        "${self}/secrets/public/server.crt"
    ];
    
    module = {
        # All modules are located on the path ${self}/modules/...       
        firewall = {
            enable = false;
            allowForward = true;
            tcpPorts = [ 3005 ];
            udpPorts = [ 3005 ];
            
        };
        ssh = {
            enable = true;
            fail2ban.enable = true;
            only-client = false;
        };

        homelab = {
            enable = true;
            domain = "avelle.com";
            
            reverseProxy = {
                enable = true;
                defaultMiddlewares = [
                    "compress"
                    "secureHeaders"
                    "websocket"
                ];
            };

            services = {
                nfs = {
                    enable = true;
                    mediaLocation = "/mnt/files/nfs";
                    allowedIp = "192.168.1.0/24";
                };

                forgejo = {
                    enable = true;
                    subdomain = "git";
                    port = 3000;
                };

                harmonia = {
                    enable = true;
                    subdomain = "cache";
                    port = 4343;
                };

                vaultwarden = {
                    enable = true;
                    subdomain = "vaultwarden";
                    port = 8222;
                };

                calibre = {
                    enable = true;
                    port = 3004;
                    mediaLocation = "/mnt/files/nfs/ebooks:/config/ebooks";
                };
                
                immich = {
                    enable = true;
                    port = 2283;
                    mediaLocation = "/mnt/files/immich";
                };

                grafana = {
                    enable = true;
                    port = 3001;
                };

                prometheus = {
                    enable = true;
                    port = 9999;
                };
            };
        };

        # netbird.enable = true;
    };
    
    users = {
        users.${systemConfig.userName} = {
            password = "1234";
            shell = pkgs.fish;
            extraGroups = [ "docker" ];
        };
    };
}
