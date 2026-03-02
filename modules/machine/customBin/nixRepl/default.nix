{
    lib,
    config,
    pkgs,
    pathsConfig,
    machine,
    ...
}:
let
    name = "nix-repl";
    cfg = config.module.customBin.${name};
in
with lib; {

    options.module.customBin.${name} = {
        enable = mkEnableOption "Enables custom nix-repl script";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [
            (pkgs.writeShellScriptBin "nix-repl" ''
                #!/bin/sh

                nix-repl() {
                    nix repl --expr "import ${pathsConfig.flakeDir}/lib/repl.nix { flakeDir = ${pathsConfig.flakeDir}; machine = \"${machine}\"; }"
                }                

                nix-repl
            '')
        ];   
    };
}
