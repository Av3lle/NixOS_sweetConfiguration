{
    self,
    lib,
    extraAttrs,
    withRoot,
    _imports,
    pkgs,
    options,
    inputs,
    ...
}:
{
    machine ? {},
    branch ? {},
    system ? {},
    paths ? {}
}:
let
    defaultBranch = {
        branch = "stable";
    };
    
    defaultSystem = {
        hostName = "nixos";
        userName = "sweet";
        platform = "x86_64-linux";
        version = "25.05";

        defaultLocale = "en_US.UTF-8";
        timeZone = "null";

        isServer = false;
        isLaptop = false;
    };

    branchConfig = defaultBranch // branch;
    systemConfig = defaultSystem // system;
in
lib.nixosSystem {
    inherit
        pkgs
        ;
    system = systemConfig.platform;
    specialArgs = extraAttrs // {
        inherit
            machine
            branchConfig
            systemConfig
            paths
            ;
    };
    modules = withRoot [
        "machine"
        "secrets/sops.nix"
    ]
    ++ (_imports.allDefaultSubdir {
        dir = (self) + /modules/machine;
    })
    ++ (withRoot [ "machine/${machine}" ])
    ++ (lib.optional (!systemConfig.isServer)
           extraAttrs.inputs.home-manager.nixosModules.default
       )
    ++ [
        (import ./options.nix {
            inherit
                lib
                ;
        })
        
        (import ./config.nix {
          inherit
              lib
              pkgs
              systemConfig
              options
              extraAttrs
              ;
        })
    ];
}
