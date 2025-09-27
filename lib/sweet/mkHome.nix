{
    self, lib, mkDefault,
    extraAttrs, withRoot,
    _imports, pkgs, options,
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
    ++ [{
        nixpkgs.config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };

        home = {
            username = system.userName;
            homeDirectory = "/home/${mergedSystem.userName}";
            stateVersion = "${mergedSystem.version}";
        };

        news.display = "silent";

        manual = {
            html = options.off;
            json = options.off;
            manpages = options.off;
        };
    }];
}
