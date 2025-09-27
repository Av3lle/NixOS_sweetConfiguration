{ self, config, pkgs, lib, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) str;

    name = "zapret";
    cfg = config.module.${name};

    zapretFiles = "${self}/modules/hosts/zapret";
    zapretBin = "${zapretFiles}/bin";
    zapretNfqws = "${zapretFiles}/bin/nfqws";

    nft = "${pkgs.nftables}/bin/nft";
  
    zapretService = pkgs.writeShellScriptBin "zapret-service" ''
        #!/bin/sh
    
        ${zapretNfqws} --daemon --qnum 0 \
            --hostlist="${zapretFiles}/list-general.txt" \
            --dpi-desync=fake \
            --dpi-desync-repeats=6 \
            --dpi-desync-fake-quic="${zapretBin}/quic_initial_www_google_com.bin" \
            --new

        ${zapretNfqws} --daemon --qnum 1 \
            --ipset="${zapretFiles}/ipset-discord.txt" \
            --dpi-desync=fake \
            --dpi-desync-any-protocol \
            --dpi-desync-cutoff=d3 \
            --dpi-desync-repeats=6 \
            --new
        
        ${zapretNfqws} --daemon --qnum 2 \
            --hostlist="${zapretFiles}/list-general.txt" \
            --dpi-desync=fake,split2 \
            --dpi-desync-autottl=2 \
            --dpi-desync-fooling=md5sig \
            --new
        
        ${zapretNfqws} --daemon --qnum 3 \
            --hostlist="${zapretFiles}/list-general.txt" \
            --dpi-desync=fake,split \
            --dpi-desync-autottl=2 \
            --dpi-desync-repeats=6 \
            --dpi-desync-fooling=badseq \
            --dpi-desync-fake-tls="${zapretBin}/tls_clienthello_www_google_com.bin"
        
        while true; do sleep infinity; done
    '';

  
    nftSetup = pkgs.writeShellScriptBin "zapret-nft" ''
        #!/bin/sh
    
        if ${nft} list tables | grep -q "inet zapret"; then
            ${nft} flush chain inet zapret output
            ${nft} delete chain inet zapret output
            ${nft}  delete table inet zapret
        fi
    
        ${nft} add table inet zapret
        ${nft} add chain inet zapret output '{ type filter hook output priority 0; }'
    
        ${nft} add rule inet zapret output oifname ${cfg.interface} \
            udp dport 443 counter queue num 0 bypass
        ${nft} add rule inet zapret output oifname ${cfg.interface} \
            udp dport 50000-50100 counter queue num 1 bypass
    
        ${nft} add rule inet zapret output oifname ${cfg.interface} \
            tcp dport 80 counter queue num 2 bypass
        ${nft} add rule inet zapret output oifname ${cfg.interface} \
            tcp dport 443 counter queue num 3 bypass
    '';
in {
    options.module.${name} = {
    enable = mkEnableOption "Enables Zapret";

    interface = mkOption {
        description = "Choice interface";
        type = str;
        default = "enp6s0";
      };
    };
  
    config = mkIf cfg.enable {
        systemd.services.zapret = {
            description = "Zapret blocking service";
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
    
            serviceConfig = {
                ExecStartPre = "${nftSetup}/bin/zapret-nft";
                ExecStart = "${zapretService}/bin/zapret-service";
                Restart = "on-failure";
            };
        };
        environment.systemPackages = [ pkgs.nftables ];
    };
}
