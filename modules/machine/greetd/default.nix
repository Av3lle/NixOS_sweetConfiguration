{ lib, config, pkgs, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) bool;

    name = "greetd";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enables greetd";

        startx = mkOption {
            description = "Enables startx";
            type = bool;
            default = false;
        };
    };

    config = mkIf cfg.enable {
        services = {
            xserver.displayManager.startx.enable = cfg.startx;
            greetd = {
                enable = true;
                settings.default_session = {
                    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --time-format '%I:%M %p | %a • %h |' --cmd 'Hyprland 1> /dev/null'";
                    user = "greeter";
                };
            };
        };
    };
}
