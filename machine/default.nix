# Here are the settings that apply
# to all hosts without exception.

{ pkgs, config, ... }: {
    # nix store settings
    # nix = {
    #     settings = {
    #         auto-optimise-store = true;
    #         experimental-features = [ "nix-command" "flakes" ];
    #         substituters = [
    #             "https://cache.nixos.org"
    #             "https://nix-community.cachix.org"
    #             "https://nixos-bunny-proxy.cofob.dev/"
    #             "https://nixos.tvix.store/"
    #             "https://nixos-cache-proxy.cofob.dev/"
    #         ];
    #     };
    #     optimise.automatic = true;
    #     gc = {
    #         automatic = true;
    #         dates = "weekly";
    #         options = "--delete-older-than 3d";
    #     };
    # };

    # Date time and locale
    # time.timeZone = "Europe/Moscow";
    # i18n = {
    #     defaultLocale = "ru_RU.UTF-8";
    #     extraLocaleSettings = { LANG = "ru_RU.UTF-8"; };
    # };

    # TTY settings
    # console = {
    #     earlySetup = true;
    #     font = "${pkgs.terminus_font}/share/consolefonts/ter-c20b.psf.gz";
    #     packages = with pkgs; [ terminus_font ];
    #     keyMap = "us";
    # };
    

    # Default services
    # systemd.services.NetworkManager-wait-online.enable = false;
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
        
        # libinput = {
        #     enable = true;
        #     mouse.accelProfile = "flat";
        # };

        # devmon.enable = true;
        # gvfs.enable = true; 
        # udisks2.enable = true;
    };
    

    # Remove sudo and add doas
    security = {
        sudo = { enable = true; };
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
            noto-fonts-emoji
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
            glxinfo
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
