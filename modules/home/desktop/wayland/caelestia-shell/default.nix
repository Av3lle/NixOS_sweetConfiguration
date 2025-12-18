{
  self,
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  name = "caelestia-shell";
  cfg = config.module.desktop.wayland.${name};
in
{
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
          kbLayoutChanged = false;
        };

        bar = {
          excludedScreens = [ "HDMI-A-1" ];
          status = {
            showBattery = false;
            showNetwork = false;
            showBluetooth = false;

            showKbLayout = true;
            showAudio = true;
          };
          scrollActions = {
            brightness = false;
            workspaces = true;
            volume = false;
          };

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

        lock.recolourLogo = true;
        osd.enabled = false;
        session.dragThreshold = 50;
        sidebar.dragThreshold = 5;

        paths.wallpaperDir = "~/Pictures/wallpaper/";
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
