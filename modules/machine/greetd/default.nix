{
  lib,
  config,
  systemConfig,
  pkgs,
  ...
}:
let
  name = "greetd";
  cfg = config.module.${name};
in
with lib; {
  options.module.${name} = {
    enable = mkEnableOption "Enable greetd";

    startx = mkOption {
      description = "Enables startx";
      type = types.bool;
      default = false;
    };

    autologin = mkOption {
      description = "Autologin configuration";
      type = types.submodule {
        options = {
          enable = mkEnableOption "Enable autologin";

          session = mkOption {
            description = "Command to start autologin session";
            type = types.str;
            default = "";
          };
        };
      };
      default = {
        enable = false;
        session = "";
      };
    };
  };
  
  config = mkIf cfg.enable {
    services = {
      xserver.displayManager.startx.enable = cfg.startx;
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --remember --time --time-format '%I:%M %p | %a • %h |'
              ";
              # --cmd 'Hyprland 1> /dev/null'
              # ";
            user = "greeter";
          };
        } // lib.optionalAttrs (cfg.autologin.enable) {
          initial_session = {
            command = cfg.autologin.session;
            user = systemConfig.userName;
          };
        };
      };
    };
  };
}
