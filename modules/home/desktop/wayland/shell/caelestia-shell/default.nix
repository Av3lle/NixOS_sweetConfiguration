{
  config,
  systemConfig,
  pathsConfig,
  lib,
  inputs,
  self,
  pkgs,
  ...
}:
let
  name = "caelestia-shell";
  cfg = config.module.desktop.wayland.${name};

  # material-symbols-caelestia = pkgs.material-symbols.overrideAttrs (attrs: {
  #   postInstall = ''
  #     ln -s "$out/share/fonts/TTF/MaterialSymbolsRounded.ttf" "$out/share/fonts/TTF/MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf"
  #     ln -s "$out/share/fonts/TTF/MaterialSymbolsOutlined.ttf" "$out/share/fonts/TTF/MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf"
  #     ln -s "$out/share/fonts/TTF/MaterialSymbolsSharp.ttf" "$out/share/fonts/TTF/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf"
  #   '';
  # });
in
with lib; {
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  options.module.desktop.wayland.${name} = {
    enable = mkEnableOption "Enable module";
  };

  config = mkIf cfg.enable {
    # home.packages = [ material-symbols-caelestia ];
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
          # mediaGif = "${self}/assets/gifs/Hello-Kitty.gif";
          # sessionGif = "${self}/assets/gifs/Tux.gif";
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
