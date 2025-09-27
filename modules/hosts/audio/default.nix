{ lib, config, pkgs, ...}: let
    inherit (lib) mkEnableOption  mkIf;

    name = "audio";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enables audio";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [ pkgs.pavucontrol ];
        
        security.rtkit.enable = true;
        
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
            wireplumber.enable = true;
            extraConfig = {
                pipewire."10-sound" = {
                    "context.properties" = {
                        default.clock.rate = 48000;
                        default.clock.allow-rates = [ 44100 48000 96000 192000 ];
                        default.clock.min-quantum = 1024;
                        default.clock.quantum = 4096;
                        default.clock.max-quantum = 8192;
                    };
                    "pulse.properties" = {
                        "pulse.min.req" = "1024/48000";
                        "pulse.default.req" = "4096/48000";
                        "pulse.max.req" = "8192/48000";
                        "pulse.min.quantum" = "1024/48000";
                        "pulse.max.quantum" = "8192/48000";
                    };
                    "stream.properties" = {
                        "node.latency" = "2048/44100";
                        "resample.quality" = 4;
                    };
                };
            };
        };
    };
}
