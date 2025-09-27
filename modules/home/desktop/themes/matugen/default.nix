{ config, lib, inputs, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "matugen";
    cfg = config.module.desktop.stylix.${name};
in {
    imports = [ inputs.matugen.nixosModules.default ];
    
    options.module.desktop.stylix.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            # inputs.matugen.packages."x86_64-linux".default
            matugen
        ];
        # programs.matugen.enable = true;
    };
}
