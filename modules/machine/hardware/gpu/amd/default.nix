{
    config,
    lib,
    pkgs,
    ...
}:
let
    name = "amd";
    cfg = config.module.hardware.gpu.${name};
in
with lib; {
    options.module.hardware.gpu.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        boot = {
            initrd.kernelModules = [ "amdgpu" ];
            extraModprobeConfig = ''
                options amdgpu si_support=1 cik_support=1
                options radeon si_support=0 cik_support=0
            '';
        };
        environment.systemPackages = [ pkgs.lact ];                                                                                                                                                                                                                                                                                                                                           
        systemd.services.lact = {
            enable = true;
            description = "AMDGPU Control Daemon";
            after = [ "multi-user.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
                ExecStart = "${pkgs.lact}/bin/lact daemon";
            };
        };
        
        environment.variables = {
            RUSTICL_ENABLE = "radeonsi";
            ROC_ENABLE_PRE_VEGA = 1;
        };
    };
}
