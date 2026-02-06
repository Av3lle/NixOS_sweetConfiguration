# modules/machine/appimage.nix
# { moduleTemplate, ... }:

# moduleTemplate "appimage" {
#   # ← сюда приходят cfg, config, pkgs, lib

#   programs.appimage = {
#     enable = true;
#     # binfmt = cfg.binfmt or true;  # если захочешь добавить опции
#   };

#   # можно больше ничего не писать — mkIf уже обёрнут в шаблоне
# }



# { m, config, pkgs, lib, ... }: m "appimage" {
#         programs.appimage = {
#             enable = true;
#             binfmt = true;
#         };
# }


# { config, lib, pkgs, ... }: let
#   m = import ./../../../lib/sweet/moduleTemplate.nix { inherit lib; };
# in

# m "appimage" {
#   programs.appimage = {
#     enable = true;
#     binfmt = true;
#   };
# }


# modules/machine/appimage.nix
{ module, ... }:

module "appimage" {
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
