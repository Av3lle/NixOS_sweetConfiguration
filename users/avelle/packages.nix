{
    pkgs,
    inputs,
    ...
}:
{
    home = {
        packages = (with pkgs; [
            # Files
            nautilus
            libsForQt5.dolphin
            kdePackages.ark
            audacious
            mpv
            xfce.ristretto
            xfce.tumbler
            rawtherapee

            gnome-clocks
            lutris
            obs-studio
            prismlauncher
            (obsidian.override { commandLineArgs = [ "--ozone-platform=wayland" ]; })
            inputs.zen-browser.packages."x86_64-linux".twilight
        ])
        ++ (with pkgs._unstable; [
            yandex-music
            qbittorrent
        ]);
    };
}
