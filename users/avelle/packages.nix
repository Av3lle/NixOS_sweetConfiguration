{ pkgs, inputs, ... }: {
    home = {
        packages = (with pkgs; [
            # Files
            nautilus
            kdePackages.ark
            audacious
            mpv
            xfce.ristretto
            xfce.tumbler
            rawtherapee

            
            lutris
            bottles
	          obs-studio
            prismlauncher
            (obsidian.override { commandLineArgs = [ "--ozone-platform=wayland" ]; })
            inputs.zen-browser.packages."x86_64-linux".twilight
        ]) ++
        (with pkgs._unstable; [
            yandex-music
            qbittorrent
        ]);
    };
}
