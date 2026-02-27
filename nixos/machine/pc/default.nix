{
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
        exclusions = [ "quickshell.nix" ];
    });

    boot = {
        kernelPackages =
        # pkgs.linuxPackages_xanmod;
        pkgs.linuxPackages_cachyos-lts;
        kernelModules = [ "ntsync" ];
    };

    services.xserver.videoDrivers = [ "vmware" ];
    virtualisation.vmware = {
        host.enable = true;
        guest.enable = true;
    };
    # Winboat
    virtualisation.docker.enable = true;

    programs.anime-game-launcher.enable = true;
    nix.settings = inputs.aagl.nixConfig;

    module = {
        # enable = true;
        uutils.enable = true;
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

        rebuild = {
            enable = true;
            nhEnable = true;
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
            lsfg.enable = true;
        };

        waydroid.enable = true;
        stylix.enable = false;
        netbird.enable = true;
        zapret.enable = false;
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
        envfs.enable = false;
    };

    programs.java = {
        enable = true;
        package = pkgs.jre25_minimal;
    };

    users = {
        users.${systemConfig.userName} = {
            hashedPasswordFile = config.sops.secrets."pc/user/password".path;
            extraGroups = [ "docker" ];
            shell = pkgs.fish;
        };
    };
}
