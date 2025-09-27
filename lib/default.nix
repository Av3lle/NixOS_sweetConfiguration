inputs@{
    self,
    nixpkgs,
    _unstable,
    _prev,
    home-manager,
    ...
}:
    let
        extraAttrs = {
            inherit
                self
                inputs
                _imports
                ;
        };

        withRoot = paths: map (path: self + "/${path}") paths;

        options = import ./sweet/options.nix { inherit (nixpkgs) lib; };

        _imports = import ./sweet/imports.nix { inherit (nixpkgs) lib; };
        
        packages = host: import ./packages.nix {
            system = host.system.platform or "x86_64-linux";
            inherit
                nixpkgs
                _unstable
                _prev
                self
                ;
        };

        devShells = host: import ./devShells.nix {
            pkgs = (packages host).pkgs;
        };

        hosts = import ../configuration.nix;

        mkMachine = host: import ./sweet/mkMachine.nix {
            inherit
                self
                extraAttrs
                withRoot
                options
                _imports
                ;
            inherit (nixpkgs) lib;
            pkgs = (packages host).pkgs;
            
        };

        mkHome = host: import ./sweet/mkHome.nix {
            inherit
                self
                extraAttrs
                withRoot
                options
                _imports
                ;
            inherit (home-manager) lib;
            inherit (nixpkgs.lib) mkDefault;
            pkgs = (packages host).pkgs;
        };

    in {

        nixosConfigurations = builtins.mapAttrs (machine: config: let
            result = (mkMachine config) {
                machine = machine;
                system = config.system;
                paths = config.paths;
            };
        in result) hosts;

        homeConfigurations = builtins.mapAttrs (machine: config: let
            result = (mkHome config) {
                machine = machine;
                system = config.system;
                paths = config.paths;
            };
        in result) hosts;
        
        devShells = let
            shellsBySystem = builtins.foldl' (acc: machine: let
                config = hosts.${machine};
                system = config.system.platform or "x86_64-linux";
                shells = devShells config;
            in acc // {
                ${system} = (acc.${system} or {}) // shells;
            }) {} (builtins.attrNames hosts);
        in shellsBySystem;
}
