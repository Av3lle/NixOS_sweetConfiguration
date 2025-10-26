{ config, pkgs, inputs, lib, ... }: let
    disableImport = [ "" ];

    importSystemDirectory = map
        (f: ./system + "/${f}")
        (lib.lists.filter
            (f: lib.strings.hasSuffix ".nix" f && !(builtins.elem f disableImport))
            (builtins.attrNames (builtins.readDir ./system)));
in {
    imports = [
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
    ] ++ importSystemDirectory;

    module = {
        # All modules are located on the path ${self}/modules/...

        boot = {
            enable = true;
        };
    
        amd = {
            enable = true;
            # Change this value to your own!i
            #
            # Use `cpuid -1 -l 1 -r | sed -n 's/.*eax=0x\([0-9a-f]*\).*/\U\1/p'`
            # to get the model ID of your CPU
            # 
            # For more information, see ${self}/modules/amd/default.nix
            cpuModelId = "00A20F12";
        };

        audio.enable = true;
        firewall.enable = true;

        ssh = {
            enable = true;
            fail2ban.enable = true;
        };

        greetd = {
            enable = true;
            startx = true;
        };

        zapret.enable = true;
    };
    
    networking = {
        hostName = "${config.laptop.hostname}";
        networkmanager.enable = true;
    };

    home-manager = {
       useGlobalPkgs = true;
       useUserPackages = true; 
       extraSpecialArgs = { inherit inputs; };
    };

    users = {
        mutableUsers = false;
        users.root = {
            # hashedPasswordFile = config.laptop.password;
            password = "1234";
        };
        users.${config.laptop.username} = {
            isNormalUser = true;
            # hashedPasswordFile = config.laptop.password;
            password = "12345";
            extraGroups  = [ "wheel" "networkmanager" "inputs" ];
            shell = pkgs.fish;
            ignoreShellProgramCheck = true;
        };
    };
}
