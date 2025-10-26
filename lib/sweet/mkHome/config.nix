{
    options,
    system,
    mergedSystem,
    ...
}:
{    
    nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
        permittedInsecurePackages = [
            "mbedtls-2.28.10"
        ];
    };

    home = {
        username = system.userName;
        homeDirectory = "/home/${mergedSystem.userName}";
        stateVersion = "${mergedSystem.version}";
    };

    news.display = "silent";

    manual = {
        html = options.off;
        json = options.off;
        manpages = options.off;
    };
}
