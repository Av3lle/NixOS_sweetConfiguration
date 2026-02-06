{
    options,
    systemConfig,
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
        enableNixpkgsReleaseCheck = false;

        username = systemConfig.userName;
        homeDirectory = "/home/${systemConfig.userName}";
        stateVersion = "${systemConfig.version}";
    };

    news.display = "silent";
    xdg.configFile."mimeapps.list".force = true;

    manual = {
        html = options.off;
        json = options.off;
        manpages = options.off;
    };
}
