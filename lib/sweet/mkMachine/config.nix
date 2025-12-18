{
    lib,
    pkgs,
    mergedSystem,
    options,
    extraAttrs,
    ...
}:
{
    config = {
        boot = {
            kernelParams = [
                "quiet"
                "splash"
                "tsc=reliable"
                "clocksource=tsc"
                "preempt=full"
            ] ++ lib.optionals (
                    !mergedSystem.isServer &&
                    !mergedSystem.isLaptop
                )
            [
                "mitigations=off"
                "split_lock_detect=off"
            ];
            
            kernel.sysctl = {
                enable = true;
                "vm.vfs_cache_pressure" = 100;
                "vm.max_map_count" = 2147483642;
            } // lib.optionalAttrs (
                    !mergedSystem.isServer &&
                    !mergedSystem.isLaptop
                )
            {
                "kernel.split_lock_mitigate" = 0;
                "kernel.nmi_watchdog" = 0;
                "net.core.netdev_max_backlog" = 4096;
                # "vm.swappiness" = 30;
            };
            extraModprobeConfig = lib.mkIf (
                    !mergedSystem.isServer &&
                    !mergedSystem.isLaptop
                )
            ''
                blacklist iTCO_wdt
                blacklist iTCO_vendor_support
                blacklist sp5100_tco
            '';
                
        
            
            loader = {
                timeout = 0;
                efi.canTouchEfiVariables = true;
                grub = {
                    enable = true;
                    efiSupport = true;
                    device = "nodev";
                    timeoutStyle = "countdown";
                    configurationLimit = 4;
                };
            };
            consoleLogLevel = 0;
            initrd.verbose = false;
            tmp.cleanOnBoot = true;
        };
        systemd.services.NetworkManager-wait-online.enable = false;
        networking = {
            hostName = mergedSystem.hostName;
            networkmanager.enable = true;
            useDHCP = options.on;
        };

        time.timeZone = mergedSystem.timeZone;
        i18n = {
            defaultLocale = mergedSystem.defaultLocale;
            extraLocaleSettings = {
                LANG = mergedSystem.defaultLocale;
            };
        };
        
        nix = {
            settings = {
                auto-optimise-store = true;
                experimental-features = [
                    "nix-command"
                    "flakes"
                ];
                substituters = [
                    "https://cache.nixos.org"
                    "https://nix-community.cachix.org"
                ];
            };
            optimise.automatic = true;
            gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 3d";
            };
        };

        environment.enableAllTerminfo = true;
        # xdg.terminal-exec = {
            # enable = true;
            # package = pkgs.kitty;
        # };
        console = {
            earlySetup = true;
            font = "${pkgs.terminus_font}/share/consolefonts/ter-c20b.psf.gz";
            packages = with pkgs; [
                terminus_font
            ];
            keyMap = "us";
        };

        security = {
            polkit = {
                enable = true;
                debug = true;
                extraConfig = ''
                    polkit.addRule(function(action, subject) {
                        if ((
                            action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
                            action.id == "org.freedesktop.udisks2.encrypted-unlock-system"
                        ) && subject.isInGroup("wheel")) {
                            return polkit.Result.YES;
                        }});
                '';
            };
            wrappers.mount_nfs = {
                source = "${pkgs.nfs-utils}/bin/mount.nfs";
                owner = "root";
                group = "root";
                setuid = true;
            };
            rtkit.enable = true;
        };

        services = lib.mkIf (!mergedSystem.isServer) {
            devmon.enable = true;
            gvfs.enable = true; 
            udisks2.enable = true;

            libinput = {
                enable = true;
                mouse.accelProfile = "flat";
            };

            pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                jack.enable = true;
                wireplumber.enable = true;
                extraConfig = {
                    pipewire."10-sound" = {
                        "context.properties" = {
                            default.clock.rate = 48000;
                            default.clock.allow-rates = [ 44100 48000 96000 192000 ];
                            default.clock.min-quantum = 1024;
                            default.clock.quantum = 4096;
                            default.clock.max-quantum = 8192;
                        };
                        "pulse.properties" = {
                            "pulse.min.req" = "1024/48000";
                            "pulse.default.req" = "4096/48000";
                            "pulse.max.req" = "8192/48000";
                            "pulse.min.quantum" = "1024/48000";
                            "pulse.max.quantum" = "8192/48000";
                        };
                        "stream.properties" = {
                            "node.latency" = "2048/44100";
                            "resample.quality" = 4;
                        };
                    };
                };
            };
        };

        programs = {
            nm-applet = lib.mkIf (!mergedSystem.isServer) {
                enable = true;
                indicator = true;
            };

            nano = options.off;
        };
        
        users = {
            mutableUsers = false;
            users.${mergedSystem.userName} = {
                isNormalUser = true;
                extraGroups = [
                    "wheel"
                    "networkmanager"
                ];
                ignoreShellProgramCheck = true;
            };
        };

        

        # home-manager = lib.mkIf (!mergedSystem.isServer) {
        #     useGlobalPkgs = true;
        #     useUserPackages = true;
        #     backupFileExtension = "bak";
        #     extraSpecialArgs = {
        #         inherit (extraAttrs)
        #             inputs
        #             ;
        #         };
        # };

        documentation = {
            dev = options.off;
            doc = options.off;
            info = options.off;
            nixos = options.off;
        };
        
        system.stateVersion = mergedSystem.version;
    } //
    lib.optionalAttrs (!mergedSystem.isServer) {
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            extraSpecialArgs = {
                inherit (extraAttrs)
                inputs
                ;
            };
        };
    };
}
