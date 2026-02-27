{ self, lib, config, inputs, pkgs, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) str;

    name = "stylix";
    cfg = config.module.${name};
in {
    imports = [
        inputs.stylix.nixosModules.stylix
        # inputs.stylix.homeModules.stylix
    ];

    options.module.${name} = {
        enable = mkEnableOption "Enables stylix";    
    };

    config = mkIf cfg.enable {
        programs.dconf.enable = true;

        stylix = {
            enable = true;
            # overlays.enable = true;
            autoEnable = false;
            image = (self + "/wallpaper/${config.wallpaper}");

            targets = {
                console.enable = true;
                # helix.enable = true;  
                # gtk.enable = true;
            };

            cursor = {
                package = pkgs.bibata-cursors;
                name = "Bibata-Modern-Ice";
                size = 24;
            };
        };
    };
}
