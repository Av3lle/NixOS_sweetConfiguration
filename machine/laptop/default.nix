{
    config,
    systemConfig,
    pkgs,
    _imports,
    ...
}:
{
    imports = [
        ./hardware-configuration.nix
    ]
    ++ (_imports.allDefaultDir {
        dir = ./system;
        exclusions = [ "quickshell.nix" ];
    });

    boot = {
        kernelPackages = pkgs.linuxPackages_cachyos-lts;
        kernelModules = [ "ntsync" ];
    };

    module = {
        # enable = true;
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
            enable = false;
            allowForward = true;
            tcpPorts = [ 25565 67 53 9997 ];
            udpPorts = [ 25565 67 53 ];
        };
        ssh = {
            enable = true;
            # only-client = false;
            # rootLogin = "yes";
            fail2ban.enable = true;
        };

        rebuild.enable = true;

        greetd = {
            enable = true;
            startx = true;
            autologin = {
                enable = true;
                session = "Hyprland 1> /dev/null";
            };
        };

        gaming = {
            enable = true;
            steam.enable = true;
        };
    };

    services = {
        ananicy = {
            enable = true;
            package = pkgs.ananicy-cpp;
            rulesProvider = pkgs.ananicy-rules-cachyos;
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
