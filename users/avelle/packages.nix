{
  pkgs,
  ...
}:
{
  home = {
    packages =
      (with pkgs; [
        nautilus
        file-roller
        audacious
        mpv
        xfce.ristretto
        xfce.tumbler
        rawtherapee

        gnome-clocks
        lutris
        protonplus
        obs-studio
        prismlauncher
        (obsidian.override { commandLineArgs = [ "--ozone-platform=wayland" ]; })
      ])
      ++ (with pkgs._unstable; [
        yandex-music
        qbittorrent
        todoist-electron
      ]);
  };
}
