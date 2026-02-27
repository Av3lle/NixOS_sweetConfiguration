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
    defaults = import ../common.nix {
        inherit
            machine
            branch
            system
            paths
            ;
    };

    inherit (defaults)
        branchConfig
        systemConfig
        pathsConfig
        ;
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
            pathsConfig
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
