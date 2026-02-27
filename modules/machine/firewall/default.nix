{ lib, config, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) str port listOf bool;

    name = "firewall";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enables firewall";

        tcpPorts = mkOption {
            description = "List of TCP ports to allow";
            type = listOf port;
            default = [ ];
        };

        udpPorts = mkOption {
            description = "List of UDP ports to allow";
            type = listOf port;
            default = [ ];
        };

        trustedInterfaces = mkOption {
            description = "Choice interface";
            type = listOf str;
            default = [ ];
        };

        allowForward = mkOption {
            description = "Allow Forward";
            type = bool;
            default = false;
        };
    };
        
    config = mkIf cfg.enable {
        networking.firewall = {
            enable = true;
            allowedUDPPorts = cfg.udpPorts;
            allowedTCPPorts = cfg.tcpPorts;

            allowPing = true;

            trustedInterfaces = [
                "lo"
            ]
            ++ cfg.trustedInterfaces;
            # ++ (lib.optionals (cfg.trustedInterfaces != "") [ cfg.trustedInterfaces ]);

            extraCommands = ''
                iptables -A INPUT -i lo -j ACCEPT
                ${lib.concatMapStrings (iface: ''
                    iptables -A INPUT -i ${iface} -j ACCEPT
                '') cfg.trustedInterfaces}
            
                 
                iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
                iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

                
                ${lib.concatMapStrings (port: ''
                    iptables -A INPUT -p tcp --dport ${toString port} -j ACCEPT
                    iptables -A INPUT -p udp --dport ${toString port} -j ACCEPT
                '') (cfg.tcpPorts ++ cfg.udpPorts)}

                iptables -P FORWARD DROP
                ${lib.optionalString cfg.allowForward ''
                    iptables -P FORWARD ACCEPT
                ''}
            
                iptables -P OUTPUT ACCEPT
            '';
        };
    };
}
