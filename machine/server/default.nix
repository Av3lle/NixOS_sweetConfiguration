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

    security.pki.certificates = [
    ''
        -----BEGIN CERTIFICATE-----
        MIIDvDCCAqSgAwIBAgIUe0ogNTCdF/Ip1nZefwV7qIob840wDQYJKoZIhvcNAQEL
        BQAwWzELMAkGA1UEBhMCUlUxCzAJBgNVBAgMAlNUMQowCAYDVQQHDAFMMQ8wDQYD
        VQQKDAZhdmVsbGUxCzAJBgNVBAsMAklUMRUwEwYDVQQDDAwqLmF2ZWxsZS5jb20w
        HhcNMjYwMzI0MjMwOTUwWhcNMjcwMzI0MjMwOTUwWjBbMQswCQYDVQQGEwJSVTEL
        MAkGA1UECAwCU1QxCjAIBgNVBAcMAUwxDzANBgNVBAoMBmF2ZWxsZTELMAkGA1UE
        CwwCSVQxFTATBgNVBAMMDCouYXZlbGxlLmNvbTCCASIwDQYJKoZIhvcNAQEBBQAD
        ggEPADCCAQoCggEBAOdVd9ZMFgzyiIpErQmLHmA4QE0kMyOSWY0nKNVX99d0O2Sk
        +1Gurz+juhYe+CwpV0udtZF3JbEjyMrP0+CDOR1DKiBIVptpsVJm9ADleV1/dhr4
        tFBO0kHLvP23g1AlxTWWtop78NMNMQgbpxMc+Dr7LP2J/lxhU+0KT978uItxF4SW
        hQQol0KruSEwpYwMdnJXl6RM7LkF4dE1kSOM/Ld+lO2U8gkaaBrTzxev4X14xJuA
        F2vMSSVM0b4D7NCsjX6MQa0o2BLiUZ4EA0Q70pkVDWvXJVYTlBMsl3o73OD1L6iT
        HwiWrrQk2Vct4ZW0rBvlqYrtamIv/TKXRR72N2cCAwEAAaN4MHYwHQYDVR0OBBYE
        FHP0rRA271sf1xOYspJl+/qrxTIaMB8GA1UdIwQYMBaAFHP0rRA271sf1xOYspJl
        +/qrxTIaMA8GA1UdEwEB/wQFMAMBAf8wIwYDVR0RBBwwGoIMKi5hdmVsbGUuY29t
        ggphdmVsbGUuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQDYOfgActHBbJofIspbSSJi
        lHpAUVubw06en9QtBGJ8aPhpkxN5g8NzHHYYICwRQK5+qrE9Zbgey/UrCefdD+Wu
        Efq0RwRJ9/08os740KScOd/4jIvEsJSDJn0ScSxiKNd7n08juzFtfTMQFnTp7Xe3
        CGyT4nRPOzQlUXnbN+WBCDJdabsr7tERnPGNvBP5UTwdyEhnvPgx6fNFcVwePmio
        BkbvjZdh/V4Xz4VL4QyBDSP73IUbGKxkfLw0g3yKJoGtqEeZn6Ptb331j/OqshU2
        BBL2cN+sscQXTuGZaaIy3JvQizM89c7PoKUsjlvj9jbd2NNuqqhWsuCAMYoKr/a3
        -----END CERTIFICATE-----
    ''
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

                cache = {
                    enable = true;
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

        netbird.enable = true;
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
