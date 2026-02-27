{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "wal-telegram";
  version = "0.6.4";
  src = pkgs.fetchzip {
    url = "https://github.com/guillaumeboehm/wal-telegram/archive/refs/tags/v0.6.4.zip";
    sha256 = "sha256-yWuVKIDhKH+Q/6rtnENFsalP5AAT64WRvndnSmx13n8=";
    stripRoot = true;
  };
  
  unpackPhase = ''
    mkdir -p $out/usr/share
  '';

  installPhase = ''
    cd $src
    install -Dm644 ./LICENSE "$out/usr/share/licenses/wal-telegram-git/LICENSE"
    install -Dm755 ./wal-telegram "$out/usr/share/wal-telegram/wal-telegram"
    install -Dm644 ./colors.wt-constants "$out/usr/share/wal-telegram/colors.wt-constants"
    echo "/bin/sh -c \"$out/usr/share/wal-telegram/wal-telegram \$*\"" >> $out/shortcut
    install -Dm755 $out/shortcut "$out/bin/wal-telegram"
  '';

  # fixupPhase = ''
    # convert_image=$(nix eval --raw nixpkgs#imagemagick.outPath)/bin/magick
    # sed -i "s/magick convert \"$@\"/$convert_image convert \"$@\""
  # '';
}
