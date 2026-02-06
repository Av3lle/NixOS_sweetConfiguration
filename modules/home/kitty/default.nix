{
    config,
    lib,
    ...
}:
let
    name = "kitty";
    cfg = config.module.${name};
in
with lib; {
    options.module.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        home.sessionVariables = {
            TERM = "kitty";
            TERMINAL = "kitty";
        };
        xdg.terminal-exec.settings = {
            default = [
                kitty.desktop
            ];
        };
        
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
                scrollback_lines = 5000;
                enabled_layouts = "tall";
            };
            keybindings = {
                "alt+enter" = "new_window_with_cwd";
                "ctrl+alt+w" = "close_window";
                
                "alt+t" = "new_tab_with_cwd";
                

                "alt+1" = "first_window";
                "alt+2" = "second_window";
                "alt+3" = "third_window";
                "alt+4" = "fourth_window";
                "alt+5" = "fifth_window";
                "alt+6" = "sixth_window";
                "alt+7" = "seventh_window";
                "alt+8" = "eighth_window";
                "alt+9" = "ninth_window";
                "alt+0" = "tenth_window";
            };
        };
    };
}
