{ config, lib, inputs, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "stylix";
    cfg = config.module.desktop.${name};
in {
    imports = [
        inputs.stylix.homeModules.stylix
    ];
    
    options.module.desktop.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        stylix = {
            enable = true;
            autoEnable = false;
            base16Scheme = ./base16/classic.yaml;
            
            iconTheme = {
                enable = true;
                package = pkgs.papirus-icon-theme.override { color = "black"; };
                light = "Papirus";
                dark = "Papirus-Dark";
            };        
            targets = {
                gtk.enable = true;
                qt.enable = true;
                kitty = {
                    enable = true;
                    variant256Colors = true;
                };
                helix.enable = true;
            };

            cursor = {
                package = pkgs.bibata-cursors;
                name = "Bibata-Modern-Ice";
                size = 24;
            };
        };
    };
}
