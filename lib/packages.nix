{
lib,
system,
selectedNixpkgs,
nixpkgs-stable ? null,
nixpkgs-unstable ? null,
nixpkgs-prev ? null,
self,
...
}: let
    overlays = {
        stable = final: prev: let
            stableInput = if nixpkgs-stable != null then
                nixpkgs-stable else selectedNixpkgs;
            stablePkgs = if selectedNixpkgs != stableInput then
                import stableInput {
                    config.allowUnfree = true;
                    inherit
                        system
                        ;
                }
            else final;
        in {
            _stable = stablePkgs;
        };
        
        unstable = final: prev: let
            unstableInput = if nixpkgs-unstable != null then
                nixpkgs-unstable else selectedNixpkgs;
            unstablePkgs = if selectedNixpkgs != unstableInput then
                import unstableInput {
                    config.allowUnfree = true;
                    inherit
                        system
                        ;
                }
            else final;
        in {
            _unstable = unstablePkgs;
        };
    
        prev = final: prev: let
            prevInput = if nixpkgs-prev != null then
                nixpkgs-prev else selectedNixpkgs;
            prevPkgs = if selectedNixpkgs != prevInput then
                import prevInput {
                    config.allowUnfree = true;
                    inherit
                    system
                    ; }
            else final;
        in {
            _24 = prevPkgs;
        };

        customPackages = final: prev:
            prev.lib.mapAttrs
            (name: type:
                if type == "directory" then
                    final.callPackage (self + "/derivations/${name}/default.nix") {}
                else
                    null
            )
            (builtins.readDir (self + "/derivations"));
    };
    overlayList = [
        overlays.customPackages
    ] ++ lib.optionals (selectedNixpkgs != nixpkgs-stable) [ overlays.stable ]
      ++ lib.optionals (selectedNixpkgs != nixpkgs-unstable) [ overlays.unstable ]
      ++ lib.optionals (selectedNixpkgs != nixpkgs-prev) [ overlays.prev ];
    
    pkgs = import selectedNixpkgs {
        inherit
            system
            ;
        overlays = overlayList;
        config.allowUnfree = true;
    };
in {
    inherit
        pkgs
        ;
}
