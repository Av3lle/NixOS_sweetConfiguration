{
  config,
  ...
}:
{
  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [
        "Telegram"
        "sleep 2;vesktop --disable-features=WebRtcAllowInputVolumeAdjustment"
      ];

      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$browser" = "zen-twilight";

      monitor = [
        "DP-1,preferred,0x0,auto"
        "HDMI-A-1,1920x1080@60,auto-up,1"
        "Unknown-1,disable"
      ];

      misc = {
        vrr = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      input = {
        kb_layout = "us,ru";
        kb_variant = "";
        kb_model = "";
        kb_options = "grp:alt_shift_toggle";
        kb_rules = "";

        repeat_rate = 30;
        repeat_delay = 350;

        follow_mouse = 0;

        sensitivity = -0.8;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(ffffffff)";
        "col.inactive_border" = "rgba(1e2327fa)";

        layout = "dwindle";

        no_border_on_floating = false;

        allow_tearing = false;
      };

      decoration = {
        rounding = 19;
        inactive_opacity = 0.8;

        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
          ignore_opacity = true;
          xray = false;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "main, 0.39, 0.575, 0.565, 1";
        
        animation = [
          "windows, 1, 3, main"
          "windowsIn, 1, 3.5, main, popin"
          "windowsOut, 1, 3, main, popin"
          
          "border, 1, 15, default"
          "borderangle, 1, 10, default"
          "fade, 1, 5, default"
          
          "workspaces, 1, 2.5, main, slidevert"
        ];
      };

      windowrulev2 = [
        "size 382 215,class:(zen-twilight),title:(Картинка в картинке)"
        "float,class:(zen-twilight),title:(Картинка в картинке)"
        "pin,class:(zen-twilight),title:(Картинка в картинке)"
        "size 1070 624,class:(zen-twilight)$,title:(Введите имя файла для сохранения…)"
        "workspace 2 silent,class:(zen-twilight)"
        "size 1600 900,class:(zen-twilight)"
        "float,class:(zen-twilight)"
        "center,class:(zen-twilight)"
        "move 1527 813,class:(zen-twilight),title:(Картинка в картинке)"

        "workspace 8 silent,class:^(org.telegram.desktop)$"
        "workspace 8 silent,class:^(vesktop)$"

        "workspace 9 silent,class:^(steam)$,title:^(Список друзей)$"
        "size 372 979,class:^(steam)$,title:^(Список друзей)$"
        "float,class:^(steam)$,title:^(Список друзей)$"
        "workspace 9 silent,class:^(steam)$"
        "move 1527 35,class:^(steam)$,title:^(Список друзей)$"

        "fullscreen,class:^(steam_app_.*)$"
        "monitor 0,class:^(steam_app_.*)$"
        "workspace 10 silent,class:^(steam_app_.*)$"
      ];
      
      workspace = [
        "1, monitor:DP-1,default:true"
        "2, monitor:DP-1,default:true"
        "3, monitor:DP-1,default:true"
        "4, monitor:DP-1,default:true"
        "5, monitor:DP-1,default:true"
        "6, monitor:DP-1,default:true"
        "7, monitor:DP-1,default:true"
        "8, monitor:DP-1,default:true"
        "9, monitor:DP-1,default:true"
        "10, monitor:DP-1,border:false,rounding:false,default:true"
        "11, monitor:HDMI-A-1,special:true,rounding:false,decorate:false,border:false,gapsin:0,gapsout:0,default:true"
      ];

      bind = [
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, f, exec, $fileManager"
        "$mainMod, w, exec, $browser"

        "$mainMod, D, exec, caelestia shell drawers toggle launcher"
        "$mainMod Shift, P, exec, caelestia shell drawers toggle session"
        
        "ALT, Tab, cyclenext,"
        "ALT, Tab, bringactivetotop,"

        "$mainMod Shift, S, exec, hyprshot -m region --clipboard-only --freez"

        ", code:122, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", code:123, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"

        "$mainMod, Q, killactive"
        "$mainMod Shift, Q, exec, hyprctl kill"
        "$mainMod Shift, Space, togglefloating"
        "$mainMod Shift, F, fullscreen"

        "$mainMod ALT, right, moveactive, 50 0"
        "$mainMod ALT, left, moveactive, -50 0"
        "$mainMod ALT, up, moveactive, 0 -50"
        "$mainMod ALT, down, moveactive, 0 50"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        # "$mainMod, L, workspace, 11"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
