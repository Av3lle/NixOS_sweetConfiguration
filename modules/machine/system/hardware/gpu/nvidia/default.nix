{ lib, config, pkgs, ... }:
let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) str;

    name = "nvidia";
    cfg = config.module.hardware.gpu.${name};
in
{
    options.module.hardware.gpu.${name} = {
        enable = mkEnableOption "Enables NVIDIA";

        package = mkOption {
            description = "Choice version nvidia driver";
            type = str;
            default = "stable";
        };
    };

    config = mkIf cfg.enable {
        boot = {
            initrd.kernelModules = [ "nvidia_drm" ];
            # extraModprobeConfig = ''
                # options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0 NVreg_DynamicPowerManagement=0x02
            # '';
        };
        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.${cfg.package};
            modesetting.enable = true;
            open = true;
            nvidiaSettings = true;
            powerManagement = {
                enable = false;
                finegrained = false;
            };
        };
    
        environment.variables = {
            GBM_BACKEND = "nvidia-drm";
            LIBVA_DRIVER_NAME = "nvidia";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            __GL_SHADER_DISK_CACHE = "1";
            __GL_SHADER_DISK_CACHE_SIZE = "12000000000";
        };

        environment.systemPackages = with pkgs; [
            vulkan-loader
            vulkan-tools
        ];
    };
}
