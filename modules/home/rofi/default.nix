{ config, lib, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "rofi";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        programs.rofi = {
            enable = true;
            package = pkgs.rofi-wayland;
        };
        
        home.file = {
            ".config/rofi/launcher" = { source = ./launcher; };
            ".config/rofi/powermenu" = { source = ./powermenu; };
        };
    };
}
