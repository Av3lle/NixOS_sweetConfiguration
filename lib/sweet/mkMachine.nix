{
    self, lib, extraAttrs,
    withRoot, _imports, pkgs,
    options,
    ...
}:
{
    machine ? {},
    system ? {},
    paths ? {}
}:
let
    defaultSystem = {
        hostName = "nixos";
        userName = "sweet";
        platform = "x86_64-linux";
        version = "25.05";

        isServer = false;
        isLaptop = false;
    };

    mergedSystem = defaultSystem // system;
in
lib.nixosSystem {
    # inherit
        # pkgs
        # ;
    system = mergedSystem.platform;
    specialArgs = extraAttrs // {
        inherit
            machine
            system
            paths
            ;
    };
    modules = [ { nixpkgs.pkgs = pkgs; } ]
    ++withRoot [
        "hosts"
        "secrets/sops.nix"
    ]
    ++ (_imports.allDefaultSubdir {
        dir = (self) + /modules/hosts;
    })
    ++ (withRoot [ "hosts/${machine}" ])
    ++ [ extraAttrs.inputs.home-manager.nixosModules.default ]
    ++ [{
        networking = {
            hostName = mergedSystem.hostName;
            networkmanager.enable = true;
            useDHCP = options.on;
        };

        environment.enableAllTerminfo = true;


        programs = {
            nm-applet = lib.mkIf (!mergedSystem.isServer) {
                enable = true;
                indicator = true;
            };

            nano = options.off;
        };

        documentation = {
            dev = options.off;
            doc = options.off;
            info = options.off;
            nixos = options.off;
        };

        
        users = {
            mutableUsers = false;
            users.${mergedSystem.userName} = {
                isNormalUser = true;
                extraGroups = [ "wheel" "networkmanager" ];
                ignoreShellProgramCheck = true;
            };
        };

        home-manager = lib.mkIf (!mergedSystem.isServer) {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            extraSpecialArgs = { inherit (extraAttrs) inputs; };
        };

        security = {
            polkit.enable = true;
            soteria.enable = true;
        };
        
        system.stateVersion = mergedSystem.version;
    }];
}
