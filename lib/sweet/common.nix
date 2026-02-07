{
    machine ? {},
    branch ? {},
    system ? {},
    paths ? {}
}:
let
    defaultBranch = {
        branch = "stable";
    };
    
    defaultSystem = {
        hostName = "nixos";
        userName = "sweet";
        platform = "x86_64-linux";
        version = "25.05";

        defaultLocale = "en_US.UTF-8";
        timeZone = "null";

        isServer = false;
        isLaptop = false;
    };
    

    branchConfig = defaultBranch // branch;
    systemConfig = defaultSystem // system;

    defaultPaths = {
        flakeDir = "/etc/nixos";
        wallpapersDir = "/home/${systemConfig.userName}/.wallpapers";
    };
    
    pathsConfig = defaultPaths // paths;
in {
  inherit
    branchConfig
    systemConfig
    pathsConfig
    ;
}
