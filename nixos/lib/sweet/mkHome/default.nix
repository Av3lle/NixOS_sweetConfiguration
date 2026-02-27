{
    self,
    lib,
    mkDefault,
    extraAttrs,
    withRoot,
    _imports,
    pkgs,
    options,
    ...
}:
{
    machine ? {},
    branch ? {},
    system ? {},
    paths ? {},
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
lib.homeManagerConfiguration {
    inherit
        pkgs
        ;
    extraSpecialArgs = extraAttrs // {
        inherit
            machine
            branchConfig
            systemConfig
            pathsConfig
            ;
    };

    modules = withRoot [
        "users/${systemConfig.userName}"
    ]
    ++ (_imports.allDefaultSubdir {
            dir = (self) + /modules/home;
    })
    ++ [
        (import ./config.nix {
            inherit
                pkgs
                options
                systemConfig
                extraAttrs
                lib
                ;
        })
    ];
}
