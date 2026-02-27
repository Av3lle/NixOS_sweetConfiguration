{
  pkgs,
  inputs,
  ...
}:
{
  home = {
    packages =
      (with pkgs; [
        # Files
        nautilus
        file-roller
        audacious
        mpv
        xfce.ristretto
        xfce.tumbler
        rawtherapee

        lutris
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
