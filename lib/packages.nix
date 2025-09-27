{
system,
nixpkgs,
_unstable,
_prev,
self,
...
}: let
    overlays = {
        unstable = final: prev: {
            _unstable = import _unstable {
                inherit
                    system
                    ;
                config.allowUnfree = true;
            };
        };
        prev = final: prev: {
            _24 = import _prev {
                inherit
                    system
                    ;
                config.allowUnfree = true;
            };
        };

        customPackages = final: prev:
            nixpkgs.lib.mapAttrs
            (name: type:
                if type == "directory" then
                    final.callPackage (self + "/derivations/${name}/default.nix") {}
                else
                    null
            )
            (builtins.readDir (self + "/derivations"));
    };
    pkgs = import nixpkgs {
        inherit
            system
            ;
        overlays = [
            overlays.unstable
            overlays.prev
            overlays.customPackages
        ];
        config.allowUnfree = true;
    };
in {
    inherit
        pkgs
        ;
}
