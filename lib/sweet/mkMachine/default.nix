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
    system ? {},
    paths ? {}
}:
let
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

    mergedSystem = defaultSystem // system;
in
lib.nixosSystem {
    inherit
        pkgs
        ;
    system = mergedSystem.platform;
    specialArgs = extraAttrs // {
        inherit
            machine
            system
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
    # ++ (_imports.allDefaultSubdir {
        # dir = (self) + /modules/test;
    # })
    ++ (withRoot [ "machine/${machine}" ])
    ++ (lib.optional (!mergedSystem.isServer)
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
              mergedSystem
              options
              extraAttrs
              ;
        })
    ];
}
