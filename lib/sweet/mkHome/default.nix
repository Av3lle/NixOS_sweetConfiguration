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
}: let
    defaultBranch = {
        branch = "stable";
    };
    
    defaultSystem = {
        userName = "sweet";
        version = "25.05";

        isLaptop = false;
    };
    defaultPaths = {
        flakeDir = "/etc/nixos";
        wallpapersDir = "/home/${systemConfig.userName}/.wallpapers";
    };

    branchConfig = defaultBranch // branch;
    systemConfig = defaultSystem // system;
    pathsConfig = defaultPaths // paths;
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
