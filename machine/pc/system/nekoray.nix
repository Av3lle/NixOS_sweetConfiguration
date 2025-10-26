{ pkgs, inputs, ... }: {
    programs.nekoray = {
        enable = true;
        tunMode.enable = true;
        package = pkgs.nekoray;
        # package = inputs.nekoflake.packages."x86_64-linux".nekoray;
    };
}
