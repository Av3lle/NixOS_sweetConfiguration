{
  config,
  systemConfig,
  pathsConfig,
  lib,
  inputs,
  self,
  ...
}:
let
  name = "caelestia-shell";
  cfg = config.module.desktop.wayland.${name};
in
with lib; {
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  options.module.desktop.wayland.${name} = {
    enable = mkEnableOption "Enable module";
  };

  config = mkIf cfg.enable {
    programs.caelestia = {
      enable = true;
      systemd.enable = true;
      settings = {
        # appearance = {
        #   mediaGifSpeedAdjustment = 0.00001;
        #   sessionGifSpeed = 50;
        # };
        general = {
          # logo = "caelestia";
          idle = {
            timeouts = [
              {
                timeout = 2100;
                idleAction = "lock";
              }
            ];
          };
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
            showBattery = if systemConfig.isLaptop then true else false;
            showBluetooth = if systemConfig.isLaptop then true else false;
            showNetwork = false;

            showKbLayout = true;
            showAudio = true;
          };
          tray = {
            background = true;
            compact = true;
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
        osd.enabled = if systemConfig.isLaptop then true else false;
        session.dragThreshold = 50;
        sidebar.dragThreshold = 5;

        paths = {
          mediaGif = "${self}/assets/gifs/honeypie.gif";
          sessionGif = "${self}/assets/gifs/Tux.gif";
          wallpaperDir = "${pathsConfig.wallpapersDir}";
        };
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
