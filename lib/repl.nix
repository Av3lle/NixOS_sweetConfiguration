{
  machine,
  flakeDir,
  ...
}:
let
  flakePathStr = toString flakeDir;
  flake = builtins.getFlake flakePathStr;
  nixos = flake.nixosConfigurations.${machine};
  inherit
    (nixos)
    options
    ;
in
nixos // {
  inherit
    flake
    ;
  home = let
    hm = flake.homeConfigurations.${machine} or flake.homeConfigurations.nixd or {};
  in {
    config = hm.config or {};
    options = hm.options or {};
  } //
  {
    options =
      options.home-manager.users.type.getSubOptions [ ] //
        (flake.homeConfigurations.nixd or {}).options;
  };
}
