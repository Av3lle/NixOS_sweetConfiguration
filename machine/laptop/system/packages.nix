{
    inputs,
    pkgs,
    ...
}:
{
  imports = with inputs; [
    chaotic.nixosModules.nyx-cache
    chaotic.nixosModules.nyx-overlay
    chaotic.nixosModules.nyx-registry
  ];

  environment = {
    systemPackages =
      (with pkgs; [
        home-manager
        gnome-disk-utility
        pwvucontrol
        (writeShellScriptBin "pavucontrol" ''
          exec pwvucontrol "$@"
        '')
        libreoffice
        ayugram-desktop
      ])
      ++
        (with pkgs._24; [
          anydesk
        ]);
  };
}
