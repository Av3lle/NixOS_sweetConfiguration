{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "pywal-discord";
  src = pkgs.fetchzip {
    url = "https://github.com/franekxtb/pywal-discord/archive/refs/heads/master.zip";
    sha256 = "sha256-WJJgi7ljW1qF14289eagT2AhwK4jsG0kcUc/m4uXTq4=";
    stripRoot = true;
  };
  
  unpackPhase = ''
    mkdir -p $out/usr/share
    mkdir $out/bin
  '';
  
  installPhase = ''
    cd $src
    install -Dm755 "$src/pywal-discord" $out/bin/pywal-discord
    cp -r "$src/config" $out/usr/share/pywal-discord/
  '';

  fixupPhase = ''
    # escaped_out=$(printf %q "$out")
    # sed -i 's/config="\/usr\/share\/pywal-discord"/config="$escaped_out\/usr\/share\/pywal-discord"/g' $out/bin/pywal-discord
    sed -i "7iconfig=\"$out/usr/share/pywal-discord\"" $out/bin/pywal-discord
  '';
}
