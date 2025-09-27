{ config, lib, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "waybar";
    cfg = config.module.desktop.wayland.${name};
in {
    options.module.desktop.wayland.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        programs.waybar = {
            enable = true;
            package = pkgs._unstable.waybar;
            systemd.enable = true;
            style = ''
                @import url("/home/${config.home.username}/.config/waybar/main.css");
            '';
        };
        home.file = {
            ".config/waybar/config.jsonc".source = ./config.jsonc;
            ".config/waybar/main.css".source = ./style_.css;
        };
    };
}
