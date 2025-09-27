{ config, lib, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "hyprland";
    cfg = config.module.desktop.wayland.${name};
in {
    imports = [ ./hypr.nix ];
    
    options.module.desktop.wayland.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            swww
            hyprshot
            grim
            slurp
        ];

        wayland.windowManager.hyprland = {
            enable = true;
            package = pkgs._unstable.hyprland;
            xwayland.enable = true;
            settings = {
                debug = {
                    disable_logs = false;
                    enable_stdout_logs = true;
                };
      
                env = [
                    "XDG_CURRENT_DESKTOP,Hyprland"
                    "XDG_SESSION_DESKTOP,Hyprland"
                ];
            };
        };
    };
}
