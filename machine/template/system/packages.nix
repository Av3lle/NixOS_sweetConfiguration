{ pkgs, ... }: {
    environment = {
        systemPackages = (with pkgs; [

        ]) ++
        
        (with pkgs._unstable; [

        ]) ++
        
        (with pkgs._24; [
            
        ]);
    };
}
