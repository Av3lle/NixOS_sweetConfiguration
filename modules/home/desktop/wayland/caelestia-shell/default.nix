{ self, config, lib, inputs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "caelestia-shell";
    cfg = config.module.desktop.wayland.${name};
in {
    imports = [ inputs.caelestia-shell.homeManagerModules.default ];
    
    
    options.module.desktop.wayland.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        programs.caelestia = {
            enable = true;
            # package = inputs.caelestia-shell.packages."x86_64-linux".debug; 
            systemd.enable = true;
            settings = {
                general.idle = {
                    timeouts = [
                        {
                            timeout = 2100;
                            idleAction = "lock";
                        }
                    ];
                };

                utilities.toasts = {
                    configLoaded = false;
                    capsLockChanged = false;
                    numLockChanged = false;
                };
                
                bar.status = {
                    showBattery = false;
                    showNetwork = false;
                    showBluetooth = false;

                    showKbLayout = true;
                    showAudio = true;
                };

                # launcher = {
                #     actions = [
                #         {
                #             name = "Lock";
                #             enabled = false;
                #         }
                #         {
                #             name = "Sleep";
                #             enabled = false;
                #         }
                #     ];
                # };

                notifs = {
                    actionOnClick = true;
                    defaultExpireTimeout = 25000;
                };

                osd.enabled = false;
                session.dragThreshold = 5;
                sidebar.dragThreshold = 5;
                
                paths.wallpaperDir = "${self}/.wallpaper/";
            };
            cli = {
                enable = true;
                settings = {
                    theme.enableGtk = false;
                };
            };
        };
    };
}
