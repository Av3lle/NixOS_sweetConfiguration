# { lib, self, ... }:

# module: # принимает уже импортированный модуль
# let
#   filePath = __curPos.file;

#   # match: ["full" "home|machine" "rest/path/to/module"]
#   m = builtins.match ".*modules/(home|machine|test)/(.*)" filePath;
#   relative =
#     if m == null then null else builtins.elemAt m 2;

#   parts =
#     if relative == null
#     then []
#     else lib.init (lib.splitString "/" relative);

#   cfgPath = ["module"] ++ parts;
#   moduleName = lib.concatStringsSep "." parts;

# in

# { config, lib, pkgs, ... }@args:

# let
#   cfg = lib.getAttrFromPath cfgPath config;
# in
# {
#   # auto-options
#   options = lib.setAttrByPath parts {
#     enable = lib.mkEnableOption "Enable ${moduleName}";
#   };

#   # include original module
#   imports = [ module ];

#   # config becomes active only if enable = true
#   config = lib.mkIf cfg.enable (module.config or {});
# }





# mkAutoModule.nix
# { lib, self }:

# { module, filePath }:

# let
#   # Используем переданный filePath
#   m = builtins.match ".*modules/(home|machine|test)/(.*)" filePath;
#   relative =
#     if m == null then null else builtins.elemAt m 2;

#   parts =
#     if relative == null
#     then []
#     else lib.init (lib.splitString "/" relative);

#   cfgPath = ["module"] ++ parts;
#   moduleName = lib.concatStringsSep "." parts;

# in
# { config, lib, pkgs, ... }@args:

# let
#   cfg = lib.getAttrFromPath cfgPath config;
# in
# {
#   options = lib.setAttrByPath parts {
#     enable = lib.mkEnableOption "Enable ${moduleName}";
#   };

#   imports = [ module ];

#   config = lib.mkIf cfg.enable (module.config or {});
# }






# mkAutoModule.nix
# { lib, self }:

# { module, filePath }:

# let
#   # Отладка
#   _ = builtins.trace "mkAutoModule: filePath = ${filePath}" null;

#   # Регулярка: захватываем всё после (home|machine|test)/
#   m = builtins.match ".*modules/(home|machine|test)/(.*)" filePath;

#   _ = builtins.trace "match result: ${builtins.toJSON m}" null;

#   relative =
#     if m == null then
#       builtins.throw "mkAutoModule: filePath не в modules/(home|machine|test)/...: ${filePath}"
#     else
#       builtins.elemAt m 1;  # ← индекс 1, потому что m = [full, group1, group2], group2 = relative

#   _ = builtins.trace "relative path: ${relative}" null;

#   # Разбиваем на части, убираем "default.nix"
#   rawParts = lib.splitString "/" relative;
#   parts = lib.filter (p: p != "" && p != "default.nix") rawParts;

#   _ = builtins.trace "parts: ${builtins.toJSON parts}" null;

#   cfgPath = ["module"] ++ parts;
#   moduleName = lib.concatStringsSep "." parts;

# in
# { config, lib, pkgs, ... }@args:

# let
#   cfg = lib.getAttrFromPath cfgPath config;
# in
# {
#   options = lib.setAttrByPath parts {
#     enable = lib.mkEnableOption "Enable ${moduleName}";
#   };

#   imports = [ module ];

#   config = lib.mkIf cfg.enable (module.config or {});
# }



# { lib, self }:

# { module, parts }:

# let
#   moduleName = lib.concatStringsSep "." parts;
# in
# { config, lib, pkgs, ... }@args:

# let
#   cfg = lib.getAttrFromPath (["module"] ++ parts) config;
# in
# {
#   options = lib.setAttrByPath parts {
#     enable = lib.mkEnableOption "Enable module ${moduleName}";
#   };

#   imports = [ module ];

#   config = lib.mkIf cfg.enable (module.config or {});
# }



# { lib, self }:

# { module, parts }:

# let
#   moduleName = lib.concatStringsSep "." parts;
#   optionPath = ["module"] ++ parts;
# in
# { config, lib, pkgs, ... }@args:

# let
#   # Проверяем, существует ли опция
#   cfg = lib.getAttrFromPath optionPath config;
# in
# {
#   options = lib.setAttrByPath optionPath {
#     enable = lib.mkEnableOption "Enable module ${moduleName}";
#   };

#   imports = [ module ];

#   config = lib.mkIf cfg.enable (module.config or {});

#   # ОТЛАДКА
#   # _ = builtins.trace "mkAutoModule: parts=${builtins.toJSON parts}, optionPath=${builtins.toJSON optionPath}, cfg.enable=${builtins.toJSON cfg.enable}" null;
# }


# { lib, self }:

# { module, filePath }:

# let
#   m = builtins.match ".*modules/(home|machine|test)/(.*)" filePath;
#   relative = if m == null then null else builtins.elemAt m 1;
#   parts = lib.filter (p: p != "" && p != "default.nix") (lib.splitString "/" relative);
#   moduleName = lib.concatStringsSep "." parts;

# in
# { config, lib, pkgs, ... }@args:

# let
#   cfg = lib.getAttrFromPath (["module"] ++ parts) config;
# in
# {
#   options = lib.setAttrByPath parts {
#     enable = lib.mkEnableOption "Enable ${moduleName}";
#   };
#   imports = [ module ];
#   config = lib.mkIf cfg.enable (module.config or {});
# }



{ lib, self }:

{ module, parts }:

let
  moduleName = lib.concatStringsSep "." parts;
  # Путь ОПЦИИ: module.appimage
  optionPath = ["module"] ++ parts;
in
{ config, lib, pkgs, ... }@args:

let
  cfg = lib.getAttrFromPath optionPath config;
in
{
  # Создаём опцию в options.module.appimage
  options = lib.setAttrByPath optionPath {
    enable = lib.mkEnableOption "Enable module ${moduleName}";
  };

  imports = [ module ];

  config = lib.mkIf cfg.enable (module.config or {});

  # ОТЛАДКА
  # _ = builtins.trace "mkAutoModule: parts=${builtins.toJSON parts}, optionPath=${builtins.toJSON optionPath}" null;
}




# { lib, self }:

# { module, parts }:

# let
#   moduleName = lib.concatStringsSep "." parts;
# in
# { config, lib, pkgs, ... }@args:

# {
#   # Создаём options.module.<parts>.enable
#   options.module = lib.setAttrByPath parts {
#     enable = lib.mkEnableOption "Enable module ${moduleName}";
#   };

#   imports = [ module ];

#   config = lib.mkIf config.module.${lib.concatStringsSep "." parts}.enable (module.config or {});

#   # ОТЛАДКА
#   # _ = builtins.trace "mkAutoModule: parts=${builtins.toJSON parts}" null;
# }






# { lib, self }:

# { module, parts }:

# let
#   moduleName = lib.concatStringsSep "." parts;
# in
# { config, lib, pkgs, ... }@args:

# let
#   # Путь к enable
#   enablePath = ["module"] ++ parts ++ ["enable"];
#   cfg = lib.getAttrFromPath enablePath config;
# in
# {
#   # Определяем options.module как attrsOf submodule
#   options.module = lib.mkOption {
#     type = lib.types.attrsOf (lib.types.submoduleWith {
#       specialArgs = { inherit pkgs lib; };
#       modules = [ {
#         options.enable = lib.mkEnableOption "Enable module ${moduleName}";
#       } ];
#     });
#     default = {};
#   };

#   # Динамически создаём опцию
#   options = lib.setAttrByPath (["module"] ++ parts) {
#     enable = lib.mkEnableOption "Enable module ${moduleName}";
#   };

#   imports = [ module ];

#   config = lib.mkIf cfg (module.config or {});

#   # ОТЛАДКА
#   # _ = builtins.trace "mkAutoModule: parts=${builtins.toJSON parts}, enablePath=${builtins.toJSON enablePath}" null;
# }



# { lib, self }:

# { module, parts }:

# let
#   moduleName = lib.concatStringsSep "." parts;
# in
# { config, lib, pkgs, ... }@args:

# let
#   # Путь к enable
#   enablePath = ["module"] ++ parts ++ ["enable"];
#   cfg = lib.getAttrFromPath enablePath config;
# in
# {
#   # Определяем options.module как attrsOf submodule
#   options.module = lib.mkOption {
#     type = lib.types.attrsOf (lib.types.submoduleWith {
#       specialArgs = { inherit pkgs lib; };
#       modules = [ {
#         options.enable = lib.mkEnableOption "Enable module ${moduleName}";
#       } ];
#     });
#     default = {};
#   };

#   # Добавляем динамическую опцию в options.module
#   # Используем genAttrs + merge
#   options.module = lib.attrsets.recursiveUpdate options.module (
#     lib.setAttrByPath parts {
#       enable = lib.mkEnableOption "Enable module ${moduleName}";
#     }
#   );

#   imports = [ module ];

#   config = lib.mkIf cfg (module.config or {});

#   # ОТЛАДКА
#   # _ = builtins.trace "mkAutoModule: parts=${builtins.toJSON parts}" null;
# }



# { lib, self }:

# { module, parts }:

# let
#   moduleName = lib.concatStringsSep "." parts;
# in
# { config, lib, pkgs, ... }@args:

# let
#   # Путь к enable
#   enablePath = ["module"] ++ parts ++ ["enable"];
#   cfg = lib.getAttrFromPath enablePath config;
# in
# {
#   # Определяем options.module как attrsOf submodule (один раз)
#   options.module = lib.mkOption {
#     type = lib.types.attrsOf (lib.types.submoduleWith {
#       specialArgs = { inherit pkgs lib; };
#       modules = [ {
#         options.enable = lib.mkEnableOption "Enable module ${moduleName}";
#       } ];
#     });
#     default = {};
#   };

#   # Добавляем динамическую опцию в options.module
#   # Используем setAttrByPath на options
#   options = lib.setAttrByPath (["module"] ++ parts) {
#     enable = lib.mkEnableOption "Enable module ${moduleName}";
#   };

#   imports = [ module ];

#   config = lib.mkIf cfg (module.config or {});

#   # ОТЛАДКА
#   _ = builtins.trace "mkAutoModule: parts=${builtins.toJSON parts}, enablePath=${builtins.toJSON enablePath}" null;
# }



# { lib, self }:

# { module, parts }:

# let
#   moduleName = lib.concatStringsSep "." parts;
#   optionPath = ["module"] ++ parts;
# in
# { config, lib, pkgs, ... }@args:

# let
#   cfg = lib.getAttrFromPath optionPath config;
# in
# {
#   # Определяем options.module как attrsOf submodule
#   options.module = lib.mkOption {
#     type = lib.types.attrsOf lib.types.submodule;
#     default = {};
#   };

#   # Динамически добавляем опцию
#   options = lib.attrsets.recursiveUpdate options (
#     lib.setAttrByPath optionPath {
#       enable = lib.mkEnableOption "Enable module ${moduleName}";
#     }
#   );

#   imports = [ module ];

#   config = lib.mkIf cfg.enable (module.config or {});

  # _ = builtins.trace "mkAutoModule: parts=${builtins.toJSON parts}, optionPath=${builtins.toJSON optionPath}" null;
# }
