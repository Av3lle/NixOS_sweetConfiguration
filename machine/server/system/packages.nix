{ config, pkgs, ... }:{
  environment.systemPackages = with pkgs; [
      # helix
      # inxi
      # git
      # p7zip
      # rar
      # gnutar
      # zip
      # nixos-icons
      # xz
      # glxinfo
      # gzip
      # gawk
  ];
}
