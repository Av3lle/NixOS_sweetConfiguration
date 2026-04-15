{
    lib,
    config,
    inputs,
    ...
}:
let
    name = "determinateNix";
    cfg = config.module.${name};
in
with lib; {
    imports = [
        inputs.determinate.nixosModules.default
    ];
    
    options.module.${name} = {
        enable = mkEnableOption "Enable determinate nix + parallel-eval";
    };

    config = mkIf cfg.enable {
        nix.settings.experimental-features = [ "parallel-eval" ];
    };
}
