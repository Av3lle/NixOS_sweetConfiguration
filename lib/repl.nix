{
  machine,
  flakeDir,
  ...
}:
let
  flakePathStr = toString flakeDir;
  flake = builtins.getFlake flakePathStr;
  nixos = flake.nixosConfigurations.${machine};
  inherit (nixos) config options;
in
nixos // {
  inherit flake;
  home = builtins.head (
    builtins.attrValues config.home-manager.users or {}
  ) //
  {
    options =
      options.home-manager.users.type.getSubOptions [ ] //
        (flake.homeConfigurations.nixd or {}).options;
  };
}
