{ config, lib, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "wayland";
    cfg = config.module.desktop.${name};
in {    
    options.module.desktop.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            wlroots
            wl-clipboard
            wlr-randr
        ];
        # home.sessionVariables = {
        #     # PATH = "$PATH:$scrPath";
        #     WLR_NO_HARDWARE_CURSORS = 1;
        #     WLR_DRM_NO_ATOMIC = 1;
        #     QT_QPA_PLATFORM = "wayland";
        #     QT_QPA_PLATFORMTHEME = "qt5ct";
        #     QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
        #     QT_AUTO_SCREEN_SCALE_FACTOR = 1;
        #     MOZ_ENABLE_WAYLAND = 1;
        #     XCURSOR_SIZE = 24;
        #     __GL_VRR_ALLOWED = 1;
        #     XDG_SESSION_TYPE = "wayland";
        #     ELECTRON_OZONE_PLATFORM_HINT = "auto";
        #     NIXOS_OZONE_WL = 1;
        # };
    };
}
