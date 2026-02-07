{
  lib,
  config,
  systemConfig,
  # pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    # plugins = [ pkgs._unstable.hyprlandPlugins.hyprscrolling ];
    settings = {
      plugin = {
        hyprscrolling = {
          fullscreen_on_one_column = true;
          focus_fit_method = 1;
          explicit_column_widths = "0, 0, 0, 1.0";
        };
      };
      
      exec-once = [
        "vesktop"
        "Telegram"
      ];

      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$browser" = "zen-beta";

      xwayland.force_zero_scaling = true;
      ecosystem.no_update_news = true;
      misc = {
        vrr = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
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
      } // lib.optionalAttrs (systemConfig.isLaptop) {
        sensitivity = 0.5;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(ffffffff)";
        "col.inactive_border" = "rgba(1e2327fa)";

        layout =
        # "scrolling";
        # "dwindle";
        "master";

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
      } // lib.optionalAttrs (systemConfig.isLaptop) {
        enabled = "no";
      };

      windowrule = [
        "match:class zen-beta,workspace 2 silent"
        "match:class zen-beta,size 1600 900"
        "match:class zen-beta,float on"
        "match:class zen-beta,center on"
        "match:class zen-beta,match:title (Картинка в картинке),float on"
        "match:class zen-beta,match:title (Картинка в картинке),size 691 387"
        "match:class zen-beta,match:title (Картинка в картинке),move 1847 1031"
        "match:class zen-beta,match:title (Картинка в картинке),pin on"
        "match:class zen-beta,match:title (Введите имя файла для сохранения…),size 1070 624"

        "match:class net.lutris.Lutris, workspace 9 silent"
        "match:class steam,workspace 9 silent"
        "match:class steam,match:title (Список друзей),float on"
        "match:class steam,match:title (Список друзей),size 372 979"
        "match:class steam,match:title (Список друзей),move 2167 439"
        "match:class steam_app_.*,monitor 0"
        "match:class steam_app_.*,workspace 10 silent"
        "match:class steam_app_.*,fullscreen on"


        "match:class yandex-music,workspace special:music silent"
        "match:class org.telegram.desktop,workspace 8 silent"
        "match:class vesktop,workspace 8 silent"
      ];
      
      bind = [
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, f, exec, $fileManager"
        "$mainMod, w, exec, $browser"
        
        "ALT, Tab, cyclenext,"
        "ALT, Tab, bringactivetotop,"

        "$mainMod Shift, S, exec, hyprshot -m region --clipboard-only --freez"

        ", code:121, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", code:122, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", code:123, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"

        "$mainMod, Q, killactive"
        "$mainMod Shift, Q, exec, hyprctl kill"
        "$mainMod Shift, Space, togglefloating"
        "$mainMod Shift, F, fullscreen"
        "$mainMod, P, pin"

        "$mainMod ALT, right, moveactive, 50 0"
        "$mainMod ALT, left, moveactive, -50 0"
        "$mainMod ALT, up, moveactive, 0 -50"
        "$mainMod ALT, down, moveactive, 0 50"

        # "CTRL  ALT, right, layoutmsg, move +col"
        # "CTRL  ALT, left, layoutmsg, move -col"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, right, movewindow, r"

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
        "$mainMod, F1, togglespecialworkspace, music"
        "$mainMod, F2, togglespecialworkspace, social"

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

      ] ++ lib.optionals (config.module.desktop.wayland.caelestia-shell.enable) [
        "$mainMod, D, exec, caelestia shell drawers toggle launcher"
        "$mainMod Shift, P, exec, caelestia shell drawers toggle session"
      ] ++ lib.optionals (config.module.desktop.wayland.minimalism.enable) [
        "$mainMod, D, exec, anyrun"
      ];
      
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    } //
    lib.optionalAttrs (systemConfig.isLaptop) {
      monitor = [
        "eDP-1,preferred,0x0,1"
        "Unknown-1,disable"
      ];

      workspace = [
        "1, monitor:eDP-1,default:true"
        "2, monitor:eDP-1,default:true"
        "3, monitor:eDP-1,default:true"
        "4, monitor:eDP-1,default:true"
        "5, monitor:eDP-1,default:true"
        "6, monitor:eDP-1,default:true"
        "7, monitor:eDP-1,default:true"
        "8, monitor:eDP-1,default:true"
        "9, monitor:eDP-1,default:true"
        "10, monitor:eDP-1,border:false,rounding:false,default:true"

        "music, monitor:eDP-1,default:true"
      ];      
    } //
    lib.optionalAttrs (!systemConfig.isLaptop) {
      monitor = [
        "DP-1,2560x1440@240,0x0,1"
        "HDMI-A-1,1920x1080@60,auto-up,1"
        "Unknown-1,disable"
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

        "music, monitorDP-1,default:true"
      ];
    };
  };
}
