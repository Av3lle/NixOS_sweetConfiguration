{ config, lib, pkgs, ... }: let
    inherit (lib) mkEnableOption mkIf;
    
    name = "netbird";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        services.netbird = {
            enable = true;
            package = pkgs._unstable.netbird;
        };
    };
}
