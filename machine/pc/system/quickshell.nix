{ inputs, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        (inputs.quickshell.packages.${pkgs.system}.default.override {
            withJemalloc = true;
            withQtSvg = true;
            withWayland = true;
            withX11 = false;
            withPipewire = true;
            withPam = true;
            withHyprland = true;
            withI3 = false;
        })
        # quickshell
        libsForQt5.full
        # kdePackages.full
        
        kdePackages.qtstyleplugin-kvantum

        qt6.qt5compat
        qt6Packages.qt5compat
        libsForQt5.qt5.qtgraphicaleffects
        kdePackages.qtbase
        kdePackages.qtdeclarative 
    ];
}
