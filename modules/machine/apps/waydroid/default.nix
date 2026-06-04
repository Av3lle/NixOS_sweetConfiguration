{ lib, config, ...}: let
    inherit (lib) mkEnableOption mkIf;

    name = "waydroid";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enable waydroid";
    };

    config = mkIf cfg.enable {
        # /var/lib/waydroid/waydroid_base.prop
        # 
        # sys.use_memfd=true
        # gralloc.gbm.device=/dev/dri/renderD128
        # debug.stagefright.ccodec=0
        # ro.hardware.gralloc=gbm
        # ro.hardware.egl=mesa
        # ro.hardware.vulkan=radeon
        # ro.hardware.camera=v4l2
        # ro.opengles.version=196610
        # waydroid.system_ota=https://ota.waydro.id/system/lineage/waydroid_x86_64/GAPPS.json
        # waydroid.vendor_ota=https://ota.waydro.id/vendor/waydroid_x86_64/MAINLINE.json
        # waydroid.tools_version=1.5.4
        # ro.vndk.lite=true
        
        virtualisation.waydroid.enable = true;
    };
}
