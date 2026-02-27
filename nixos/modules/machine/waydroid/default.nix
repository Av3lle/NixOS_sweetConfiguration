{ lib, config, ...}: let
    inherit (lib) mkEnableOption mkIf;

    name = "waydroid";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enable waydroid";
    };

    config = mkIf cfg.enable {
        virtualisation.waydroid.enable = true;
    };
}
