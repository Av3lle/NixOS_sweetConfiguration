{
    config,
    branchConfig,
    lib,
    pkgs,
    ...
}:
let
    name = "steam";
    cfg = config.module.gaming.${name};
in
with lib; {
    options.module.gaming.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        programs = with pkgs; {
            steam = {
                enable = true;
                remotePlay.openFirewall = true;

                extraCompatPackages = [
                    proton-cachyos
                ] ++ lib.optionals (branchConfig != "unstable") [
                    (pkgs._unstable.proton-ge-bin.override {
                        steamDisplayName = "_unstable.Proton-GE";
                    })
                ] ++ lib.optionals (branchConfig == "unstable") [
                    (proton-ge-bin.override {
                        steamDisplayName = "_unstable.Proton-GE";
                    })
                ];

                package = steam.override {
                    extraArgs = lib.concatStringsSep " " [
                        "-nochatui"
                        "-nofriendsui"
                    ];
                    extraEnv = {
                        LD_PRELOAD = "";
                        PROTON_USE_NTSYNC = 1;
                        OBS_VKCAPTURE = true;
                    };
                    extraLibraries = pkgs: with pkgs; [
                        libxkbcommon
                        wayland
                    ];
                };
            };
        };
    };
}
