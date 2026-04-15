{
    lib,
    self,
    config,
    systemConfig,
    pkgs,
    _imports,
    inputs,
    ...
}:
{
    imports = [
        ./hardware-configuration.nix
        inputs.aagl.nixosModules.default
    ]
    ++ (_imports.allDefaultDir {
        dir = ./system;
        exclusions = [ ];
    });

    specialisation = {
        noKvm.configuration = {
            boot.blacklistedKernelModules = [ "kvm" "kvm_amd" ];
        };
    };

    boot = {
        kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
        kernelModules = [ "ntsync" "v4l2loopback"];
    };

    security.pki.certificateFiles = [
        "${self}/secrets/public/server.crt"
    ];

    nix.settings = {
        substituters = lib.mkBefore [ "https://cache.avelle.com?priority=1" ];
        trusted-public-keys = [
            "cache.avelle.com:0XmjRhWJF9etJZwL1X08kJDD6VyBwr+/x11XDI26Gbo="
        ];
    };

    # Winboat
    virtualisation.docker.enable = true;

    # aagl
    programs.anime-game-launcher.enable = true;

    module = {
        hardware = {
            cpu.amd = {
                enable = true;
                # Change this value to your own!i
                #
                # Use `cpuid -1 -l 1 -r | sed -n 's/.*eax=0x\([0-9a-f]*\).*/\U\1/p'`
                # to get the model ID of your CPU
                #
                # For more information, see ${self}/modules/hardware/cpu/amd/default.nix
                # cpuModelId = "00A20F12";
            };
            gpu = {
                enable = true;
                amd.enable = true;
            };
            fstrim.enable = true;
        };
        firewall = {
            enable = true;
            allowForward = true;
            tcpPorts = [ 25565 67 53 9997 9090 ];
            udpPorts = [ 25565 67 53 8080 9090 ];
        };
        ssh = {
            enable = true;
            # only-client = false;
            # rootLogin = "yes";
            fail2ban.enable = true;
        };

        customBin = {
            rebuild = {
                enable = true;
                nhEnable = true;
            };
            nix-repl.enable = true;
            gitPush.enable = true;
        };
        greetd = {
            enable = true;
            startx = true;
            autologin = {
                enable = true;
                session = "start-hyprland 1> /dev/null";
            };
        };

        gaming = {
            enable = true;
            steam.enable = true;
        };

        waydroid.enable = true;
        netbird.enable = true;
    };

    virtualisation.virtualbox.host.enable = true;
    
    services = {
        ananicy = {
            enable = true;
            package = pkgs.ananicy-cpp;
            rulesProvider = pkgs.ananicy-rules-cachyos;
        };
        prometheus.exporters.smartctl = {
            enable = true;
            port = 9997;
            openFirewall = true;
            maxInterval = "360m";
        };
    };

    users = {
        users.${systemConfig.userName} = {
            hashedPasswordFile = config.sops.secrets."pc/user/password".path;
            extraGroups = [ "docker" ];
            shell = pkgs.fish;
        };
    };
}
