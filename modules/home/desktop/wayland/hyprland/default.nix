{
    config,
    lib,
    # branchConfig,
    pkgs,
    ...
}:
let
    name = "hyprland";
    cfg = config.module.desktop.wayland.${name};
in
with lib; {
    imports = [ ./hypr.nix ];
    
    options.module.desktop.wayland.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            hyprshot
        ];

        wayland.windowManager.hyprland = {
            enable = true;
            # package = pkgs._unstable.hyprland;
            package = pkgs._master.hyprland;
                
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
