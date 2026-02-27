{
    lib,
    ...
}:
{
    options = {
        boot = {
            packages = lib.mkOption {
                type = lib.types.str;
                default = "linuxPackages_latest";
                description = "Kernel package set";
            };
        };
    };
}
