{ lib, config, ... }: let
    inherit (lib) mkEnableOption mkIf;

    name = "fstrim";
    cfg = config.module.hardware.${name};
in {
    options.module.hardware.${name} = {
        enable = mkEnableOption "Enables trim ssd";
    };

    config = mkIf cfg.enable {
        services.fstrim.enable = true;
    };
}
