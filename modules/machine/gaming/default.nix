{ config, lib, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "gaming";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        programs.gamemode = {
            enable = true;
            enableRenice = true;

            settings = {
                gpu = {
                    enable_gpu = 1;
                    gpu_device = 0;
                } //
                mkIf config.module.hardware.gpu.nvidia.enable {
                    nvidia_performance_mode = 1;
                    nvidia_powermizer_mode = 1;
                    nv_powermizer_mode = 1;
                    nvidia_vsync = 0;
                    nvidia_shader_cache = 1;
                };
                cpu = {
                    enable_cpu = 1;
                    desiredgov = "performance";
                    disable_splitlock = 1;
                    cpu_performance = 1;
                    disable_smt = 0;
                };
            };
        };

        environment = let
            mangohudConfig = pkgs.writeTextFile {
                name = "mangohud.conf";
                text = ''
                    no_display
                    legacy_layout=false
                    gpu_stats
                    gpu_temp
                    gpu_text=GPU
                    cpu_stats
                    cpu_temp
                    core_load
                    cpu_mhz
                    cpu_load_change
                    core_load_change
                    cpu_load_value=50,90
                    cpu_load_color=FFFFFF,FF7800,CC0000
                    cpu_color=2e97cb
                    cpu_text=CPU
                    io_read
                    io_write
                    io_color=a491d3
                    vram
                    vram_color=ad64c1
                    ram
                    ram_color=c26693
                    fps
                    fps_limit=0,80
                    toggle_fps_limit=F10
                    fps_limit_step=10
                    show_fps_limit
                    increase_fps_limit=Shift+Up
                    decrease_fps_limit=Shift+Down
                    engine_color=eb5b5b
                    gpu_name
                    gpu_color=2e9762
                    wine
                    winesync
                    wine_color=eb5b5b
                    frame_timing=1
                    frametime_color=00ff00
                    resolution
                    gamemode
                    exec=echo #add a line for text space
                    exec=echo #add a line for text space
                    media_player_color=ffffff
                    time
                    background_alpha=0.4
                    font_size=19
                    background_color=020202
                    position=top-left
                    text_color=ffffff
                    round_corners=10
                    toggle_hud=Shift_R+F12
                '';
            };
            
            customMangohud = pkgs.mangohud.overrideAttrs (oldAttrs: {
                nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];
                postInstall = (oldAttrs.postInstall or "") + ''
                    wrapProgram $out/bin/mangohud \
                    --set MANGOHUD_CONFIGFILE ${mangohudConfig}
                '';
            });
        in {
            systemPackages = [ customMangohud pkgs.protonplus];
            sessionVariables = {
                MANGOHUD_CONFIGFILE = "${mangohudConfig}";
            };
        };
    };
}
