{ lib, inputs, config, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) str;
    
    name = "amd";
    cfg = config.module.hardware.cpu.${name};
in {
    imports = [ inputs.ucodenix.nixosModules.default ];
    
    options.module.hardware.cpu.${name} = {
        enable = mkEnableOption "Enables third-party amd ucode";

        amd-pstate = mkOption {
            description = "Choice pstate";
            type = str;
            default = "active";
            # https://docs.kernel.org/admin-guide/pm/amd-pstate.html#active-mode
            # # other pstate --- passive, guided
        };
        cpuModelId = mkOption {
            description = "Choice cpuModelId";
            type = str;
            defaultText = ''Set your cpuModelID'';
            # example = "00A20F12";
        };
    };

    config = mkIf cfg.enable {
        boot.kernelParams = [
            "amd-pstate=${cfg.amd-pstate}"
            "microcode.amd_sha_check=off"
        ];
        services.ucodenix = {
            enable = true;
            cpuModelId = "${cfg.cpuModelId}";
        };
    };
}
