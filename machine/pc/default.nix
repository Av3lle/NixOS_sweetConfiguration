{
    config,
    lib,
    system,
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

    # system.modulesTree =
        # let
            # kernel = pkgs.linuxPackages_cachyos.kernel;
        # in
        # [ (lib.getOutput "modules" kernel) ];

    # specialisation = {
        # default.configuration = {
            # boot.kernelPackages = pkgs.linuxPackages_xanmod;
        # };
        # vanillaKernel.configuration = {
            # boot.kernelPackages = pkgs.linuxPackages_latest;
        # };
    # };
   
    boot = {
        # kernelPackages =
        # pkgs.linuxPackages_xanmod;
        # pkgs.linuxPackages_cachyos;
        kernelModules = [ "ntsync" ];
    };

    hardware.ksm.enable = true;

    # Winboat
    virtualisation.docker.enable = true;
    # users.extraGroups.docker.members = [ "username-with-access-to-socket" ];
    

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
                nvidia = {
                    enable = true;
                    package = "latest";
                };
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
        };

        gaming = {
            enable = true;
            steam.enable = true;
            lsfg.enable = true;
        };

        waydroid.enable = true;
        stylix.enable = false;
        # appimage.enable = lib.mkDefault true;
        zapret.enable = false;
    };

    virtualisation.virtualbox.host.enable = true;
    
    services = {
        xserver.windowManager.openbox.enable = true;
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
        envfs.enable = true;
    };

    users = {
        users.${system.userName} = {
            hashedPasswordFile = config.sops.secrets."pc/user/password".path;
            extraGroups = [ "docker" ];
            shell = pkgs.fish;
        };
    };
}
