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
            vesktop.enable = true;
            config = {
                frameless = true;
                plugins = {
                    noTypingAnimation.enable = true;
                    volumeBooster.enable = true;
                };
            };
        };
        home.packages = with pkgs; [
            (vesktop.overrideAttrs (finalAttrs: previousAttrs: { desktopItems = [
                ((builtins.elemAt previousAttrs.desktopItems 0).override { 
                exec = "vesktop --disable-features=WebRtcAllowInputVolumeAdjustment --ozone-platform-hint=auto --enable-webrtc-pipewire-capturer --enable-features=WaylandWindowDecorations --enable-features=UseOzonePlatform --ozone-platform=wayland --use-gl=angle --use-angle=gl --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder %U";
                })];
            }))
        ];
   };
}
