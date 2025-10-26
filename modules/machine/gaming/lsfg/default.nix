{ self, config, lib, inputs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "lsfg";
    cfg = config.module.gaming.${name};
in {
    imports = [ inputs.lsfg-vk-flake.nixosModules.default  ];
    
    options.module.gaming.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        services.lsfg-vk = {
            enable = true;
            ui.enable = true;

            losslessDLLFile = "${self}/modules/hosts/gaming/lsfg/Lossless.dll";
        };
    };
}
