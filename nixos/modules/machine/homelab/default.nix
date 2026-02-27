{
  config,
  lib,
  self,
  systemConfig,
  ...
}:

let
  name = "homelab";
  cfg = config.module.${name};
in
with lib; {
  options.module.${name} = {
    enable = mkEnableOption "Enable homelab module";

    domain = mkOption {
      description = "Base domain name";
      type = types.str;
      default = "server.com";
    };

    sslCert = mkOption {
      description = "Paths to SSL certificate and key";
      type = types.attrs;
      default = {
        certFile = "${self}/secrets/cert.pem";
        keyFile  = "${self}/secrets/cert.key";
      };
    };

    reverseProxy = mkOption {
      description = "Reverse proxy settings for services under this homelab";
      type = types.submodule {
        options = {
          enable = mkEnableOption "Enable Traefik reverse proxy for all services";

          defaultMiddlewares = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "Middlewares to apply to all proxied services";
          };
        };
      };
      default = { };
    };

    services = mkOption {
      description = "Per-service reverse proxy configuration";
      default = { };
      type = types.loaOf (types.submodule ({ name, ... }: {
        options = {
          enable = mkEnableOption "Enable reverse proxy for this service";

          subdomain = mkOption {
            description = "Subdomain (git, vault, etc.)";
            type = types.str;
            default = name;
          };

          port = mkOption {
            description = "Internal port of the service";
            type = types.port;
          };

          extraMiddlewares = mkOption {
            description = "Additional middlewares for this service only";
            type = types.listOf types.str;
            default = [ ];
          };

          mediaLocation = mkOption {
            description = "Custom media location for Immich and etc";
            type = types.nullOr types.str;
            default = null;
          };

          allowedIp = mkOption {
            description = "Allowed IP/network for NFS";
            type = types.nullOr types.str;
            default = null;
          };
        };
      }));
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 8080 ];
      allowedUDPPorts = [ 80 443 8080 ];
    };

    services.nginx.enable = false;

    services.traefik = {
      enable = true;

      staticConfigOptions = {
        api = {
          dashboard = true;
          insecure = true;
        };
        log.level = "INFO";

        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entryPoint = {
              to = "websecure";
              scheme = "https";
              permanent = true;
            };
          };

          websecure = {
            address = ":443";
          };
        };

        tls.certificates = [{
          certFile = cfg.sslCert.certFile;
          keyFile  = cfg.sslCert.keyFile;
        }];
      };
      dynamicConfigOptions.http = mkMerge [{
        middlewares = {
          websocket = {
            headers.customRequestHeaders = {
              X-Forwarded-Proto = "https";
              X-Forwarded-Ssl = "on";
              X-Forwarded-For = "{{ .RemoteAddr }}";
              X-Real-IP = "{{ .RemoteAddr }}";
            };
            headers.customResponseHeaders = {
              Strict-Transport-Security = "max-age=31536000; includeSubDomains; preload";
            };
          };
          compress = {
            compress = { };
        };

        secureHeaders = {
          headers = {
            stsSeconds = 31536000;
            stsIncludeSubdomains = true;
            stsPreload = true;
            forceSTSHeader = true;
            browserXssFilter = true;
            contentTypeNosniff = true;
            frameDeny = true;
            referrerPolicy = "strict-origin-when-cross-origin";
          };
        };
      };
      }
      (lib.mkMerge (
        lib.mapAttrsToList (svcName: svcCfg:
          lib.optionalAttrs (svcCfg.enable or false) (
            let
              portValue = builtins.tryEval (svcCfg.port or null);
              port = if portValue.success then portValue.value else null;
            in
            lib.optionalAttrs (port != null) {
              routers.${svcCfg.subdomain} = {
                rule = "Host(\"${svcCfg.subdomain}.${cfg.domain}\")";
                entryPoints = [ "websecure" ];
                service = svcCfg.subdomain;
                tls = { };
                middlewares = lib.filter (m: m != null) (
                  cfg.reverseProxy.defaultMiddlewares ++ svcCfg.extraMiddlewares
                );
              };
              services.${svcCfg.subdomain}.loadBalancer.servers = [
                { url = "http://127.0.0.1:${toString port}"; }
              ];
            }
          )
        ) cfg.services
      ))];
    };

    virtualisation = {
      containers.enable = true;
      oci-containers.backend = "docker";
      docker.enable = true;
    };

    users.users.${systemConfig.userName}.extraGroups = [ "docker" ];
  };
}
