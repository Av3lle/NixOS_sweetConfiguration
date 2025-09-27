{ lib, config, pkgs, ... }:let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) str;

    name = "boot";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enables boot params";

        packages = mkOption {
            description = "Choice kernel";
            type = str;
            default = "linuxPackages_latest";
        };  
    };

    config = mkIf cfg.enable {
        # system.modulesTree = let
        #     kernel = pkgs.linuxPackages_cachyos.kernel;
        #     # kernel = pkgs.${cfg.packages};
        # in
        # [ (lib.getOutput "modules" kernel) ];

        boot = {
            kernelPackages = pkgs.${cfg.packages};
            kernelModules = [ "ntsync" ];

            kernelParams = [
                "quiet"
                "splash"
                "tsc=reliable"
                "clocksource=tsc"
                "mitigations=off"
                "split_lock_detect=off"
                "preempt=full"
            ];
            kernel.sysctl = {
                enable = true;
                "vm.vfs_cache_pressure" = 100;
                "vm.max_map_count" = 2147483642;
                "kernel.split_lock_mitigate" = 0;
            };
            loader = {
                timeout = 0;
                efi.canTouchEfiVariables = true;
                grub = {
                    enable = true;
                    efiSupport = true;
                    device = "nodev";
                    # useOSProber = true;
                    timeoutStyle = "countdown";
                    configurationLimit = 4;
                };
            };
            consoleLogLevel = 0;
            initrd.verbose = false;
            tmp.cleanOnBoot = true;
        };
    };
}
