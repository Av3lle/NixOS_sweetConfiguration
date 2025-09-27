{ lib, config, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) str;

    name = "nvidia";    
    cfg = config.module.hardware.gpu.${name};
in {
    options.module.hardware.gpu.${name} = {
        enable = mkEnableOption "Enables novideo";

        package = mkOption {
            description = "Choice version nvidia driver";
            type = str;
            default = "latest";
        };
    };

    config = mkIf cfg.enable {
        boot.initrd.kernelModules = [ "nvidia_drm" ];
    
        services.xserver.videoDrivers = ["nvidia"];
  
        hardware.nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.${cfg.package};
        };
        environment.variables = {
            GBM_BACKEND = "nvidia-drm";
            LIBVA_DRIVER_NAME = "nvidia";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        };
    };
}
