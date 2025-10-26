inputs@{
    self,
    nixpkgs-stable ? null,
    nixpkgs-unstable ? null,
    nixpkgs-prev ? null,
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

        hosts = import ../configuration.nix;

        withRoot = paths: map (path: self + "/${path}") paths;

        defaultLib = nixpkgs-stable.lib or null;
        options = import ./sweet/options.nix { lib = defaultLib; };
        _imports = import ./sweet/imports.nix { lib = defaultLib; };

        packages = host: let
            branchToInput = {
                "stable" = nixpkgs-stable;
                "prev" = nixpkgs-prev;
                "unstable" = nixpkgs-unstable;
            };
            selectedNixpkgs = branchToInput.${host.branch or "stable"} or nixpkgs-stable;
        in import ./packages.nix {
            system = host.system.platform or "x86_64-linux";
            lib = selectedNixpkgs.lib;
            inherit
                selectedNixpkgs
                nixpkgs-stable
                nixpkgs-unstable
                nixpkgs-prev
                self
                ;
        };
    
        devShells = host: import ./devShells.nix {
            pkgs = (packages host).pkgs;
        };

        mkContext = host: let
            branchToInput = {
                "stable" = nixpkgs-stable;
                "prev" = nixpkgs-prev;
                "unstable" = nixpkgs-unstable;
            };
            selectedInput = branchToInput.${host.branch or "stable"} or nixpkgs-stable;
            pkgsForHost = (packages host).pkgs;
            system = host.system.platform or "x86_64-linux";
        in {
            lib = selectedInput.lib;
            inherit
                selectedInput
                pkgsForHost
                system
                ;
        };

        mkMachine = host: let
            context = mkContext host;
        in import ./sweet/mkMachine {
            inherit
                self
                extraAttrs
                withRoot
                options
                _imports
                ;
            inherit (context) lib;
            pkgs = context.pkgsForHost;
        };

        mkHome = host: let
            context = mkContext host;
        in import ./sweet/mkHome {
            inherit
                self
                extraAttrs
                withRoot
                options
                _imports
                ;
            inherit (home-manager) lib;
            inherit (context.lib) mkDefault;
            pkgs = context.pkgsForHost;
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
