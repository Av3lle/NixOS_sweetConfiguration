# Here are the settings that apply
# to all hosts without exception.

{
    pkgs,
    config,
    ...
}:
{
    # Default services
    services = {
        xserver = {
            enable = true;
            autorun = false;
            xkb = {
                layout = "us,ru";
                variant = " , ";
                options = "grp:alt_shift_toggle, grp_led:shift, grp:switch";
            };
        };
    };
    

    # Remove sudo and add doas
    security = {
        sudo.enable = true;
        doas = {
            enable = true;
            extraConfig = ''
                permit persist keepenv :wheel
            '';
        };
    };

    # List of fonts for the system
    fonts = {
        fontconfig.useEmbeddedBitmaps = true;
        packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
            liberation_ttf
            fira-code
            fira-code-symbols
            mplus-outline-fonts.githubRelease
            dina-font
            proggyfonts
            source-sans
            source-han-sans
            nerd-fonts.jetbrains-mono
            nerd-fonts.iosevka
            jetbrains-mono
            feather-ttf
        ];
    };

    environment = {
        systemPackages = (with pkgs; [
            git
            gawk
            inxi
            nixos-icons
            killall

            p7zip
            gzip
            zip
            gnutar
            xz
            rar
        ]) ++ (with pkgs._unstable; [
            helix
        ]);
    };

    programs = {
        dconf.enable = true;
        nix-ld = {
            enable = false;
            libraries = with pkgs; [
                icu
            ];
        };
    };

    users.users.root = {
        hashedPasswordFile = config.sops.secrets."pc/root/password".path;
        # password = "1234";
    };
}
