{ config, lib, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "kitty";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        programs.kitty = lib.mkForce {
            enable = true;
            settings = {
                font_family = "JetBrainsMono Nerd Font";
                bold_font = "auto";
                italic_font = "auto";
                bold_italic_font = "auto";
                cursor_trail = 2;
                font_size = 11.0;
                window_padding_width = 20;
                # background_opacity = 0.65;
                hide_window_decorations = "yes";
                confirm_os_window_close = 0;
            };
        };  
    };
}
