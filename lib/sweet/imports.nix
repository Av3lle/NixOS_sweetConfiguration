{
    lib,
    ...
}:
{
    allDefaultDir = { dir, exclusions ? [] }:
        let
            dirContents = builtins.readDir dir;
            nixFiles = lib.filterAttrs
            (name: type:
                type == "regular"
                && lib.hasSuffix ".nix" name
                && !builtins.elem name exclusions
            )
            dirContents;
            importFile = name: _: import (dir + "/${name}");
        in
        lib.mapAttrsToList importFile nixFiles;

    allDefaultSubdir = { dir, exclusions ? [] }:
        let
            findDefaultNix = path:
            let
                contents = builtins.readDir path;
                hasDefault = contents ? "default.nix" && !builtins.elem "default.nix" exclusions;
                subdirs = lib.filterAttrs
                (name: type:
                    type == "directory"
                    && !builtins.elem name exclusions
                )
                contents;
                subdirPaths = lib.mapAttrsToList (name: _: path + "/${name}") subdirs;
            in
            (if hasDefault then [ (import (path + "/default.nix")) ] else []) ++
            (lib.concatMap findDefaultNix subdirPaths);
        in
        findDefaultNix dir;

}
