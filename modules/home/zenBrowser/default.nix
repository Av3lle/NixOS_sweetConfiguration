{
    config,
    lib,
    inputs,
    pkgs,
    systemConfig,
    ...
}:
let
    name = "zenBrowser";
    cfg = config.module.${name};
in
with lib; {
    imports = [
        inputs.zen-browser.homeModules.default
    ];
    
    options.module.${name} = {
        enable = mkEnableOption "Enable module";

        downloadDir = mkOption {
            # description = ""
            type = types.str;
            default = "none";
        };
    };

    config = mkIf cfg.enable {
        programs.zen-browser = {
            enable = true;
            profiles.${systemConfig.userName} = {
                search = {
                    force = true;
                    engines = {
                        "Nix Packages" = {
                            urls = [{
                                template = "https://search.nixos.org/packages";
                                params = [
                                    { name = "type"; value = "packages"; }
                                    { name = "query"; value = "{searchTerms}"; }
                                ];
                            }];
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
                            definedAliases = [ "@np" ];
                        };

                        "ChatGPT" = {
                            urls = [{
                                template = "https://chatgpt.com/";
                                params = [
                                    { name = "prompt"; value = "{searchTerms}"; }
                                ];
                            }];
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
                            definedAliases = [ "@gpt" ];
                        };

                        "Grok" = {
                            urls = [{
                                template = "https://grok.com/";
                                params = [
                                    { name = "q"; value = "{searchTerms}"; }
                                ];
                            }];
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
                            definedAliases = [ "@gk" ];
                        };
                    };
                };

                containersForce = true;
                containers = {
                    "None" = {
                        color = "purple";
                        id = 0;
                    };
                };

                spacesForce = true;
                spaces = {
                    "Main" = {
                        id = "c6de089c-410d-4206-961d-ab11f988d40a";
                        icon = "⭐";
                        position = 1;
                    };

                    "Secondary" = {
                        id = "e4e750ad-c936-4949-b6b8-1ec8dc3cf156";
                        icon = "✨";
                        position = 2;
                    };
                    

                    "Ai" = {
                        id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
                        icon = "🤖";
                        position = 3;
                    };

                    "Nix" = {
                        id = "cceb6b52-d101-4c4e-8ff2-c5b658fda11f";
                        icon = "❄️";
                        position = 4;
                    };
                };

                pinsForce = true;
                pins = let
                    domain = "avelle.com";
                    spaces = config.programs.zen-browser.profiles.${systemConfig.userName}.spaces;
                in
                {
                    # Pinned tabs
                    # Закрепленные вкладки
                    "YouTube" = {
                        id = "4905bfa1-84ad-42da-b139-02c689cca335";
                        url = "https://youtube.com/";
                        isEssential = true;
                        position = 110;
                    };

                    "Monkeytype" = {
                        id = "2bd8b068-88e0-4bc8-973d-411175f854f7";
                        url = "https://monkeytype.com/";
                        isEssential = true;
                        position = 120;
                    };


                    
                    
                    # Pinned tabs on the first space
                    # Закрепленные вкладки в первом пространстве
                    "Yandex Transtale" = {
                        id = "95db8e87-339b-48d7-a6c8-2873b900045e";
                        url = "https://translate.yandex.ru/";
                        workspace = spaces.Main.id;
                        position = 210;
                    };
                    
                    "Lofi Hip-hop" = {
                        id = "59bfe6c3-a8b2-4349-9963-2efa1109a9ea";
                        url = "https://www.youtube.com/watch?v=jfKfPfyJRdk";
                        workspace = spaces.Main.id;
                        position = 220;
                    };

                    "Lofi Medieval" = {
                        id = "f7579521-43cf-4680-ac76-22c0f0f4f9aa";
                        url = "https://www.youtube.com/watch?v=IxPANmjPaek";
                        workspace = spaces.Main.id;
                        position = 230;
                    };

                    
                    
                    
                    # Pinned tabs in Second Space
                    # Закрепленные вкладки во втором пространстве
                    "OpenWrt" = {
                        id = "6b9a1a1b-94ca-4d61-ae3d-0588f02e0370";
                        url = "https://openwrt.${domain}";
                        workspace = spaces.Secondary.id;
                        position = 310;
                    };
                    
                    "Forgejo" = {
                        id = "68ceca6d-1c1e-4cab-9f0b-d2a39f4aa0b5";
                        url = "https://git.${domain}/avelle/nixos-configuration";
                        workspace = spaces.Secondary.id;
                        position = 320;
                    };

                    "Grafana" = {
                        id = "4e92947b-fcb8-49e1-b91a-2b4bf37f7bdd";
                        url = "https://grafana.${domain}";
                        workspace = spaces.Secondary.id;
                        position = 330;
                    };
                    
                    "Immich" = {
                        id = "2f1d98c6-1c8f-47d8-9c7e-ab201e9c9c03";
                        url = "https://immich.${domain}";
                        workspace = spaces.Secondary.id;
                        position = 340;
                    };

                    "Calibre" = {
                        id = "d05b7b4d-d0bc-4f1c-8f97-e9ac4977e80b";
                        url = "https://calibre.${domain}";
                        workspace = spaces.Secondary.id;
                        position = 341;
                    };




                    # Pinned tabs in Third space
                    # Закрепленные вкладки в третьем пространстве
                    "ChatGPT" = {
                        id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
                        url = "https://chatgpt.com/";
                        workspace = spaces.Ai.id;
                        position = 410;
                    };

                    "Grok" = {
                        id = "57c27ceb-a7a5-473f-8b35-553bac8d5839";
                        url = "https://grok.com/";
                        workspace = spaces.Ai.id;
                        position = 420;
                    };

                    "Perplexity" = {
                        id = "7e95900e-558e-4370-9cb5-5db21218b10b";
                        url = "https://www.perplexity.ai/";
                        workspace = spaces.Ai.id;
                        position = 430;
                    };



                    
                    # Pinned tabs in the fourth space
                    # Закрепленные вкладки в четвертом пространстве
                    "Nix packages" = {
                        id = "1b4bc738-2877-4bb6-8d6d-e411a2cd4863";
                        url = "https://search.nixos.org/packages?channel=25.11&";
                        workspace = spaces.Nix.id;
                        position = 510;
                    };

                    "Nix options" = {
                        id = "6033721f-220d-4fbf-984d-77cf2f08f9eb";
                        url = "https://search.nixos.org/options?channel=25.11&";
                        workspace = spaces.Nix.id;
                        position = 520;
                    };
                    
                    "Home-manager options" = {
                        id = "00c31aed-029a-4b80-a8bd-3f5564cee0cc";
                        url = "https://home-manager-options.extranix.com/";
                        workspace = spaces.Nix.id;
                        position = 530;
                    };

                    "MyNixos" = {
                        id = "9a092e97-ee1d-4d91-8abe-4db2ff7466f3";
                        url = "https://mynixos.com/";
                        workspace = spaces.Nix.id;
                        position = 540;
                    };
                    
                    "Noogle" = {
                        id = "5669c3aa-77f8-4e7a-ab3d-753c3e98181b";
                        url = "https://noogle.dev/";
                        workspace = spaces.Nix.id;
                        position = 550;
                    };
                    
                    "NixDev" = {
                        id = "f2902f53-91ef-42b2-9521-f7ee8ef6cc40";
                        url = "https://nix.dev/index.html";
                        workspace = spaces.Nix.id;
                        position = 560;
                    };
                };

                mods = [
                    # "ae7868dc-1fa1-469e-8b89-a5edf7ab1f24" # Load Bar  **No Working**
                    
                    "f4866f39-cfd6-4498-ab92-54213b8279dc" # Animations Plus **No Working
                    "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
                    "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar 
                    "cb15abdb-0514-4e09-8ce5-722cf1f4a20f" # Hide Extension Name 
                    "7d577b21-4685-4db2-bb17-d39d08eec199" # Bleeding Corners Fix 
                    "e51b85e6-cef5-45d4-9fff-6986637974e1" # smaller zen toast popup 
                    "c01d3e22-1cee-45c1-a25e-53c0f180eea8" # Ghost Tabs 
                ];

                settings = {
                    "intl.locale.requested" = "ru,en-US";
                    "privacy.userContext.enabled" = false; # Отключение стандартных контейнеров firefox

                    # Удаление файлов, которые скачаны в приватном режиме
                    "browser.download.deletePrivate" = true;
                    "browser.download.deletePrivate.chosen" = true;

                    "zen.view.show-newtab-button-top" = false; # Поместить кнопку "Новая вкладка" наверх (то есть, она будет внизу)
                    "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true; # Восстанавливать закреплённые вкладки с исходным адресом при запуске браузера

                    "browser.search.suggest.enabled" = true; # Показывать поисковые предложения
                    "browser.search.suggest.enabled.private" = true; # Отображать поисковые предложения в приватных окнах

                    # Удаление неиспользующихся search.engines
                    "browser.urlbar.shortcuts.bookmarks" = false;
                    "browser.urlbar.shortcuts.history" = false;
                    "browser.urlbar.shortcuts.tabs" = false;

                    # Включение строгого режима приватности
                    "browser.contentblocking.category" = "strict";
                    "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
                    "privacy.annotate_channels.strict_list.enabled" = true;
                    "privacy.bounceTrackingProtection.mode" = 1;
                    "privacy.fingerprintingProtection" = true;
                    "privacy.query_stripping.enabled" = true;
                    "privacy.query_stripping.enabled.pbmode" = true;
                    "privacy.trackingprotection.allow_list.convenience.enabled" = false;
                    "privacy.trackingprotection.consentmanager.skip.pbmode.enabled" = false;
                    "privacy.trackingprotection.emailtracking.enabled" = true;
                    "privacy.trackingprotection.enabled" = true;
                    "privacy.trackingprotection.socialtracking.enabled" = true;
                    
                    "signon.autofillForms" = false; # Автоматически заполнять имена пользователей и пароли
                    "signon.generation.enabled" = false; # Предлагать надёжные пароли
                    "signon.firefoxRelay.feature" = "disabled"; # Предлагать псевдонимы электронной почты Firefox Relay для защиты вашего адреса электронной почты
                    "extensions.formautofill.creditCards.enabled" = false; # Сохранять и автозаполнять платёжную информацию
                    
                    "browser.translations.enable" = false;

                    

                    # UI
                    "browser.tabs.inTitlebar" = 0;
                    "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action\"],\"nav-bar\":[\"customizableui-special-spring1\",\"customizableui-special-spring5\",\"customizableui-special-spring6\",\"customizableui-special-spring7\",\"customizableui-special-spring15\",\"back-button\",\"forward-button\",\"vertical-spacer\",\"urlbar-container\",\"stop-reload-button\",\"customizableui-special-spring10\",\"customizableui-special-spring9\",\"customizableui-special-spring17\",\"customizableui-special-spring8\",\"customizableui-special-spring2\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\"],\"vertical-tabs\":[],\"PersonalToolbar\":[],\"zen-sidebar-top-buttons\":[],\"zen-sidebar-foot-buttons\":[\"downloads-button\",\"zen-workspaces-button\",\"zen-create-new-button\"]},\"seen\":[\"developer-button\",\"screenshot-button\",\"firefox_tampermonkey_net-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action\"],\"dirtyAreaCache\":[\"PersonalToolbar\",\"nav-bar\",\"zen-sidebar-top-buttons\",\"toolbar-menubar\",\"TabsToolbar\",\"vertical-tabs\",\"zen-sidebar-foot-buttons\",\"unified-extensions-area\"],\"currentVersion\":23,\"newElementCount\":17}";
                } // lib.optionalAttrs (cfg.downloadDir != "none") {
                    "browser.download.dir" = cfg.downloadDir;
                    "browser.download.folderList" = 2;                   
                } ;                          

                extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
                    ublock-origin
                    translate-web-pages
                ];
            };
        };
        xdg.mimeApps = let
            associations = builtins.listToAttrs (map
            (name: {
                inherit name;
                value = "zen-beta.desktop";
            }) [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/chrome"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]);
        in
        {
            enable = true;
            associations.added = associations;
            defaultApplications = associations;
        };
    };
}
