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
    system ? {},
    paths ? {},
}: let
    defaultSystem = {
        userName = "sweet";
        version = "25.05";
    };

    mergedSystem = defaultSystem // system;
in
lib.homeManagerConfiguration {
    inherit
        pkgs
        ;
    extraSpecialArgs = extraAttrs // {
        inherit
            machine
            system
            paths
            ;
    };

    modules =
        _imports.allDefaultSubdir {
        dir = (self) + /modules/home;
    }
    ++ (withRoot [ "users/${mergedSystem.userName}" ])
    ++ [
        (import ./config.nix {
            inherit
                pkgs
                options
                system
                mergedSystem
                ;
        })
     ];
}
