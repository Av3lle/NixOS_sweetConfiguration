{
    systemConfig,
    pkgs,
    _imports,
    lib,
    config,
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

        netbird.enable = true;
        rebuild.enable = true;
    };

    services.xserver.displayManager.lightdm.enable = false;

    networking.nameservers = [ "192.168.1.1" ];


    systemd.services.factorio = {
        preStart = lib.mkAfter ''
          MOD_LIST="/var/lib/${config.services.factorio.stateDirName}/mods/mod-list.json"

          if [ -f "$MOD_LIST" ]; then
            ${pkgs.jq}/bin/jq '
              .mods |= map(
                if .name == "elevated-rails" or .name == "quality" or .name == "space-age"
                then .enabled = false
                else .
                end
              )
            ' "$MOD_LIST" > "$MOD_LIST.tmp" && mv "$MOD_LIST.tmp" "$MOD_LIST"
            chmod 664 "$MOD_LIST"  # на всякий случай, чтобы factorio мог читать/писать
          else
            # Если mod-list.json ещё не существует — создаём минимальный без DLC
            echo '{
              "mods": [
                { "name": "base", "enabled": true },
                { "name": "elevated-rails", "enabled": false },
                { "name": "quality", "enabled": false },
                { "name": "space-age", "enabled": false }
              ]
            }' > "$MOD_LIST"
            chmod 664 "$MOD_LIST"
          fi
        '';
      };

    services.factorio = {
        enable = true;
        openFirewall = true;
        lan = true;
        requireUserVerification = false;

        autosave-interval = 3;

        saveName = "_autosave3";
    };
    
    users = {
        users.${systemConfig.userName} = {
            password = "1234";
            shell = pkgs.fish;
            extraGroups = [ "docker" ];
        };
    };
}
