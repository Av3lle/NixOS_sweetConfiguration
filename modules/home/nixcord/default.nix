{ config, lib, inputs, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "nixcord";
    cfg = config.module.${name};
in {
    imports = [ inputs.nixcord.homeModules.nixcord  ];
    
    options.module.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        programs.nixcord = {
            enable = false;
            equibop.enable = true;
            vesktop.enable = true;
            config = {
                frameless = true;
                enabledThemes = [ "caelestia.theme.css" ];
                plugins = {
                    ClearURLs.enable = true;
                    noTypingAnimation.enable = true;
                    volumeBooster.enable = true;
                };
            };
        };
        home.packages = with pkgs; [
            (vesktop.overrideAttrs (finalAttrs: previousAttrs: { desktopItems = [
                ((builtins.elemAt previousAttrs.desktopItems 0).override { 
                exec = lib.concatStringsSep " " [ "vesktop"
                    "--disable-features=WebRtcAllowInputVolumeAdjustment,AudioServiceOutOfProcess"
                    "--enable-features=WaylandWindowDecorations,UseOzonePlatform,VaapiVideoDecodeLinuxGL"
                    "--ozone-platform-hint=auto"
                    "--ozone-platform=wayland"
                    "--use-gl=desktop"
                    "--enable-webrtc-pipewire-capturer"
                    "%U"
                ];
                    # "--enable-features=WaylandWindowDecorations,UseOzonePlatform,VaapiVideoDecodeLinuxGL,VaapiVideoEncoder"
                    # "--use-gl=angle"
                    # "--use-angle=gl"
                    
                # "vesktop \
                        # --disable-features=WebRtcAllowInputVolumeAdjustment,AudioServiceOutOfProcess \
                        # --enable-features=WaylandWindowDecorations,UseOzonePlatform \
                        # --ozone-platform-hint=auto \
                        # --ozone-platform=wayland \
                        # --force_high_performance_gpu \
                        # --use-gl=angle \
                        # --use-angle=gl \
                        # --enable-webrtc-pipewire-capturer \
                        # --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder \
                        # --enable-unsafe-swiftshader %U
                    # ";
                })];
            }))
        ];
   };
}
