{ config, lib, system, pkgs, _imports, ... }: {
    imports = [
        ./hardware-configuration.nix
    ]
    ++ (_imports.allDefaultDir {
        dir = ./system;
        exclusions = ["quickshell.nix"];
    });

    system.modulesTree = let
        kernel = pkgs.linuxPackages_cachyos.kernel;
    in

    [ (lib.getOutput "modules" kernel) ];

    module = {
        # All modules are located on the path ${self}/modules/...
        boot = {
            enable = true;
            packages = "linuxPackages_cachyos"; 
        };

        hardware = {
            cpu.amd = {
                enable = true;
                # Change this value to your own!i
                #
                # Use `cpuid -1 -l 1 -r | sed -n 's/.*eax=0x\([0-9a-f]*\).*/\U\1/p'`
                # to get the model ID of your CPU
                # 
                # For more information, see ${self}/modules/hardware/cpu/amd/default.nix
                cpuModelId = "00A20F12";
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

        audio.enable = true;
        firewall = {
            enable = true;
            tcpPorts = [ 25565 ];
            udpPorts = [ 25565 ];
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

        stylix.enable = false;
        appimage.enable = true;
        zapret.enable = false;
    };
    
    services.xserver.windowManager.openbox.enable = true; 

    services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
    };
      
    users = {
        users.${system.userName} = {
            hashedPasswordFile = config.sops.secrets."pc/user/password".path;
            extraGroups  = [ "inputs" ];
            shell = pkgs.fish;
         };
    };

}
