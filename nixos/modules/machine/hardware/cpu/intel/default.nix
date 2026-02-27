{ config, lib, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "intel";
    cfg = config.module.hardware.cpu.${name};
in {    
    options.module.hardware.cpu.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        hardware.cpu.intel.updateMicrocode = true;
        services.throttled.enable = true;
    };
}
