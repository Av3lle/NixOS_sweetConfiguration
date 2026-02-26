{ pkgs }: pkgs.stdenv.mkDerivation {
  name = "feather-font";
  version = "1.0";
  src = ./feather-font-main.zip;

  unpackPhase = ''
    mkdir -p $out/share/fonts
    ${pkgs.unzip}/bin/unzip $src -d $out/share/fonts
  '';

  installPhase = ''
    mv $out/share/fonts/feather-font-main/feather.ttf $out/share/fonts/
    rm -rf $out/share/fonts/feather-font-main
  '';
}
