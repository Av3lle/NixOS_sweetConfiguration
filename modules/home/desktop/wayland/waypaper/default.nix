{ config, lib, pkgs, paths, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "waypaper";
    cfg = config.module.desktop.wayland.${name};
in {
    options.module.desktop.wayland.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        home.packages = [ pkgs.waypaper ];
        xdg.configFile."waypaper/config.ini".text = ''
            [Settings]
            language = en
            folder = ${paths.flakeDir}/wallpaper
            monitors = All
            wallpaper = ~/.config/waypaper/default.jpeg
            backend = swww
            fill = fill
            sort = name
            color = #26A269
            subfolders = False
            show_hidden = False
            show_gifs_only = False
            post_command = ~/.config/waypaper/wal.sh $wallpaper &
            number_of_columns = 3
            swww_transition_type = any
            swww_transition_step = 90
            swww_transition_angle = 0
            swww_transition_duration = 2
            swww_transition_fps = 144
            use_xdg_state = False
        '';

        home.file = {
            ".config/waypaper/default.jpeg" = { source = ./default.jpeg; };
            ".config/waypaper/wal.sh" = { source = ./wal.sh; executable = true; };
        };
    };
}
