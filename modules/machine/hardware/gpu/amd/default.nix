{ config, lib, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "amd";
    cfg = config.module.hardware.gpu.${name};
in {
    options.module.hardware.gpu.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        # hardware.amdgpu.initrd.enable = true;
        boot = {
            initrd.kernelModules = [ "amdgpu" ];
            extraModprobeConfig = ''
                options amdgpu si_support=1 cik_support=1
                options radeon si_support=0 cik_support=0
            '';
        };
        environment.systemPackages = [ pkgs.lact ];                                                                                                                                                                                                                                                                                                                                           
        systemd.packages = [ pkgs.lact ];

        environment.variables = {
            RUSTICL_ENABLE = "radeonsi";
            ROC_ENABLE_PRE_VEGA = 1;
        };
    };
}
