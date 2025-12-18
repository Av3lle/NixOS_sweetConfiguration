{
    system,
    pkgs,
    _imports,
    ...
}:
{
    imports = [
        ./hardware-configuration.nix
    ] ++ (_imports.allDefaultDir {
        dir = ./system;
    });

    module = {
        # All modules are located on the path ${self}/modules/...       
        ssh = {
            enable = true;
            fail2ban.enable = true;
            only-client = false;
        };

        netbird.enable = false;

        homelab = {
            enable = true;
            domain = "avelle.com";

            nfs = {
                enable = true;
                dir = "/mnt/files/nfs";
                ip = "192.168.1.0/24";
            };

            forgejo = {
                enable = true;
            };

            immich = {
                enable = true;
                mediaLocation = "/mnt/files/immich";
            };

            monitoring = {
                grafana.enable = true;
                prometheus.enable = true;
            };
        };

        rebuild.enable = true;
    };

    services.xserver.displayManager.lightdm.enable = false;

    networking.nameservers = [ "192.168.1.1" ];
    
    users = {
        users.${system.userName} = {
            password = "1234";
            shell = pkgs.fish;
        };
    };
}
