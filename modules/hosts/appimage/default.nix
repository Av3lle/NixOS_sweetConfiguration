{ lib, config, ... }: let
    inherit (lib) mkEnableOption mkIf;

    name = "appimage";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enables appimage run";
    };

    config = mkIf cfg.enable {
        programs.appimage = {
            enable = true;
            binfmt = true;
        };
    };
}
