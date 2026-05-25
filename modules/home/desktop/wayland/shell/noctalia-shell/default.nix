{
    config,
    pathsConfig,
    lib,
    inputs,
    ...
}:
let
    name = "noctalia-shell";
    cfg = config.module.desktop.wayland.${name};
in
with lib; {
    imports = [ inputs.noctalia.homeModules.default ];

    options.module.desktop.wayland.${name} = {
        enable = mkEnableOption "Enable module";

        wal2base16 = mkOption {
            type = types.bool;
            default = false;
        };
    };

    config = mkIf cfg.enable {
        programs.${name} = {
            enable = true;
            settings = {
                bar = {
                    barType = "simple";
                    position = "left";
                    monitors = [
                        "DP-1"
                    ];
                    density = "spacious";
                    showOutline = false;
                    showCapsule = true;
                    capsuleOpacity = 0.17;
                    capsuleColorKey = "primary";
                    widgetSpacing = 6;
                    contentPadding = 5;
                    fontScale = 1.1099999999999999;
                    enableExclusionZoneInset = true;
                    backgroundOpacity = 0.93;
                    useSeparateOpacity = false;
                    marginVertical = 4;
                    marginHorizontal = 4;
                    frameThickness = 8;
                    frameRadius = 12;
                    outerCorners = true;
                    hideOnOverview = false;
                    displayMode = "always_visible";
                    autoHideDelay = 500;
                    autoShowDelay = 150;
                    showOnWorkspaceSwitch = true;
                    widgets = {
                        left = [
                            {
                                colorizeSystemIcon = "none";
                                colorizeSystemText = "none";
                                customIconPath = "";
                                enableColorization = false;
                                icon = "rocket";
                                iconColor = "none";
                                id = "Launcher";
                                useDistroLogo = false;
                            }
                            {
                                characterCount = 1;
                                colorizeIcons = false;
                                emptyColor = "error";
                                enableScrollWheel = true;
                                focusedColor = "primary";
                                followFocusedScreen = false;
                                fontWeight = "bold";
                                groupedBorderOpacity = 1;
                                hideUnoccupied = false;
                                iconScale = 0.8;
                                id = "Workspace";
                                labelMode = "name";
                                occupiedColor = "secondary";
                                pillSize = 0.67;
                                showApplications = false;
                                showApplicationsHover = true;
                                showBadge = true;
                                showLabelsOnlyWhenOccupied = true;
                                unfocusedIconsOpacity = 1;
                            }
                        ];
                        center = [];
                        right = [
                            {
                                blacklist = [
                                    "nm-applet"
                                ];
                                chevronColor = "none";
                                colorizeIcons = false;
                                drawerEnabled = true;
                                hidePassive = false;
                                id = "Tray";
                                pinned = [];
                            }
                            {
                                displayMode = "alwaysHide";
                                iconColor = "none";
                                id = "Volume";
                                middleClickCommand = "pwvucontrol || pavucontrol";
                                textColor = "none";
                            }
                            {
                                capsLockIcon = "square-rounded-letter-c-filled";
                                hideWhenOff = false;
                                id = "LockKeys";
                                numLockIcon = "letter-n";
                                scrollLockIcon = "letter-s";
                                showCapsLock = true;
                                showNumLock = false;
                                showScrollLock = false;
                            }
                            {
                                displayMode = "forceOpen";
                                iconColor = "none";
                                id = "KeyboardLayout";
                                showIcon = true;
                                textColor = "primary";
                            }
                            {
                                clockColor = "none";
                                customFont = "CaskaydiaCove Nerd Font";
                                formatHorizontal = "HH:mm ddd, MMM dd";
                                formatVertical = "HH mm ss - dd MM";
                                id = "Clock";
                                tooltipFormat = "HH:mm ddd, MMM dd";
                                useCustomFont = false;
                            }
                            {
                                defaultSettings = {
                                    ai = {
                                        apiKeys = {};
                                        maxHistoryLength = 100;
                                        model = "gemini-2.5-flash";
                                        openaiBaseUrl = "https://api.openai.com/v1/chat/completions";
                                        openaiLocal = false;
                                        provider = "google";
                                        systemPrompt = "You are a helpful assistant integrated into a Linux desktop shell. Be concise and helpful.";
                                        temperature = 0.7;
                                    };
                                    maxHistoryLength = 100;
                                    panelDetached = true;
                                    panelHeightRatio = 0.85;
                                    panelPosition = "right";
                                    panelWidth = 520;
                                    scale = 1;
                                    translator = {
                                        backend = "google";
                                        deeplApiKey = "";
                                        realTimeTranslation = true;
                                        sourceLanguage = "auto";
                                        targetLanguage = "en";
                                    };
                                };
                                id = "plugin:assistant-panel";
                            }
                        ];
                    };
                    mouseWheelAction = "none";
                    reverseScroll = false;
                    mouseWheelWrap = true;
                    middleClickAction = "none";
                    middleClickFollowMouse = false;
                    middleClickCommand = "";
                    rightClickAction = "controlCenter";
                    rightClickFollowMouse = false;
                    rightClickCommand = "";
                    screenOverrides = [];
                };
                general = {
                    dimmerOpacity = 0;
                    showScreenCorners = false;
                    forceBlackScreenCorners = false;
                    scaleRatio = 1.1;
                    radiusRatio = 1;
                    iRadiusRatio = 1;
                    boxRadiusRatio = 1;
                    screenRadiusRatio = 1;
                    animationSpeed = 0.8;
                    animationDisabled = false;
                    compactLockScreen = false;
                    lockScreenAnimations = false;
                    lockOnSuspend = true;
                    showSessionButtonsOnLockScreen = true;
                    showHibernateOnLockScreen = false;
                    enableLockScreenMediaControls = false;
                    enableShadows = true;
                    enableBlurBehind = false;
                    shadowDirection = "bottom_right";
                    shadowOffsetX = 2;
                    shadowOffsetY = 3;
                    language = "";
                    allowPanelsOnScreenWithoutBar = true;
                    showChangelogOnStartup = true;
                    telemetryEnabled = false;
                    enableLockScreenCountdown = true;
                    lockScreenCountdownDuration = 10000;
                    autoStartAuth = false;
                    allowPasswordWithFprintd = false;
                    clockStyle = "custom";
                    clockFormat = "hh\\nmm";
                    passwordChars = false;
                    lockScreenMonitors = [
                        "DP-1"
                    ];
                    lockScreenBlur = 0;
                    lockScreenTint = 0;
                    keybinds = {
                        keyUp = [
                            "Up"
                        ];
                        keyDown = [
                            "Down"
                        ];
                        keyLeft = [
                            "Left"
                        ];
                        keyRight = [
                            "Right"
                        ];
                        keyEnter = [
                            "Return"
                            "Enter"
                        ];
                        keyEscape = [
                            "Esc"
                        ];
                        keyRemove = [
                            "Del"
                        ];
                    };
                    reverseScroll = false;
                    smoothScrollEnabled = true;
                };
                ui = {
                    fontDefault = "CaskaydiaCove Nerd Font";
                    fontFixed = "CaskaydiaCove Nerd Font Mono";
                    fontDefaultScale = 1;
                    fontFixedScale = 0.95;
                    tooltipsEnabled = false;
                    scrollbarAlwaysVisible = false;
                    boxBorderEnabled = false;
                    panelBackgroundOpacity = 1;
                    translucentWidgets = false;
                    panelsAttachedToBar = true;
                    settingsPanelMode = "attached";
                    settingsPanelSideBarCardStyle = false;
                };
                location = {
                    name = "Rostov-on-Don";
                    weatherEnabled = true;
                    weatherShowEffects = true;
                    weatherTaliaMascotAlways = false;
                    useFahrenheit = false;
                    use12hourFormat = false;
                    showWeekNumberInCalendar = false;
                    showCalendarEvents = true;
                    showCalendarWeather = true;
                    analogClockInCalendar = false;
                    firstDayOfWeek = -1;
                    hideWeatherTimezone = false;
                    hideWeatherCityName = false;
                    autoLocate = false;
                };
                calendar = {
                    cards = [
                        {
                            enabled = true;
                            id = "calendar-header-card";
                        }
                        {
                            enabled = true;
                            id = "calendar-month-card";
                        }
                        {
                            enabled = true;
                            id = "weather-card";
                        }
                    ];
                };
                wallpaper = {
                    enabled = true;
                    overviewEnabled = false;
                    directory = "${pathsConfig.wallpapersDir}";
                    monitorDirectories = [];
                    enableMultiMonitorDirectories = false;
                    showHiddenFiles = false;
                    viewMode = "single";
                    setWallpaperOnAllMonitors = true;
                    linkLightAndDarkWallpapers = true;
                    fillMode = "crop";
                    fillColor = "#000000";
                    useSolidColor = false;
                    solidColor = "#ffd6e2";
                    automationEnabled = false;
                    wallpaperChangeMode = "random";
                    randomIntervalSec = 300;
                    transitionDuration = 2000;
                    transitionType = [
                        "fade"
                        "disc"
                        "stripes"
                        "wipe"
                    ];
                    skipStartupTransition = true;
                    transitionEdgeSmoothness = 0.1;
                    panelPosition = "follow_bar";
                    hideWallpaperFilenames = false;
                    useOriginalImages = true;
                    overviewBlur = 0.4;
                    overviewTint = 0.6;
                    useWallhaven = false;
                    wallhavenQuery = "";
                    wallhavenSorting = "relevance";
                    wallhavenOrder = "desc";
                    wallhavenCategories = "111";
                    wallhavenPurity = "100";
                    wallhavenRatios = "";
                    wallhavenApiKey = "";
                    wallhavenResolutionMode = "atleast";
                    wallhavenResolutionWidth = "";
                    wallhavenResolutionHeight = "";
                    sortOrder = "name";
                    favorites = [];
                };
                appLauncher = {
                    enableClipboardHistory = true;
                    autoPasteClipboard = false;
                    enableClipPreview = true;
                    clipboardWrapText = true;
                    enableClipboardSmartIcons = true;
                    enableClipboardChips = true;
                    clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
                    clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
                    position = "follow_bar";
                    pinnedApps = [];
                    sortByMostUsed = true;
                    terminalCommand = "kitty -e";
                    customLaunchPrefixEnabled = false;
                    customLaunchPrefix = "";
                    viewMode = "list";
                    showCategories = false;
                    iconMode = "tabler";
                    showIconBackground = false;
                    enableSettingsSearch = false;
                    enableWindowsSearch = false;
                    enableSessionSearch = false;
                    ignoreMouseInput = false;
                    screenshotAnnotationTool = "";
                    overviewLayer = false;
                    density = "comfortable";
                };
                controlCenter = {
                    position = "close_to_bar_button";
                    diskPath = "/";
                    shortcuts = {
                        left = [
                            {
                                id = "WallpaperSelector";
                            }
                            {
                                id = "Notifications";
                            }
                            {
                                id = "NightLight";
                            }
                        ];
                        right = [
                            {
                                defaultSettings = {
                                    autoPaste = false;
                                    autoPasteDelay = 300;
                                    autoPasteOnRightClick = false;
                                    cardColors = {};
                                    customColors = {};
                                    enableTodoIntegration = false;
                                    fullscreenMode = false;
                                    hidePanelBackground = false;
                                    notecardsEnabled = true;
                                    panelHeight = 0;
                                    panelWidth = 1450;
                                    pincardsEnabled = true;
                                    showCloseButton = true;
                                };
                                id = "plugin:clipper";
                            }
                            {
                                defaultSettings = {
                                    completedCount = 0;
                                    count = 0;
                                    current_page_id = 0;
                                    exportEmptySections = false;
                                    exportFormat = "markdown";
                                    exportPath = "~/Documents";
                                    isExpanded = false;
                                    pages = [
                                        {
                                            id = 0;
                                            name = "General";
                                        }
                                    ];
                                    priorityColors = {
                                        high = "#f44336";
                                        low = "#9e9e9e";
                                        medium = "#2196f3";
                                    };
                                    showBackground = true;
                                    showCompleted = true;
                                    todos = [];
                                    useCustomColors = false;
                                };
                                id = "plugin:todo";
                            }
                            {
                                defaultSettings = {
                                    compactMode = false;
                                    defaultDuration = 0;
                                    iconColor = "none";
                                    textColor = "none";
                                };
                                id = "plugin:timer";
                            }
                        ];
                    };
                    cards = [
                        {
                            enabled = true;
                            id = "profile-card";
                        }
                        {
                            enabled = false;
                            id = "audio-card";
                        }
                        {
                            enabled = false;
                            id = "brightness-card";
                        }
                        {
                            enabled = true;
                            id = "weather-card";
                        }
                        {
                            enabled = true;
                            id = "media-sysmon-card";
                        }
                        {
                            enabled = true;
                            id = "shortcuts-card";
                        }
                    ];
                };
                systemMonitor = {
                    cpuWarningThreshold = 80;
                    cpuCriticalThreshold = 90;
                    tempWarningThreshold = 80;
                    tempCriticalThreshold = 90;
                    gpuWarningThreshold = 80;
                    gpuCriticalThreshold = 90;
                    memWarningThreshold = 80;
                    memCriticalThreshold = 90;
                    swapWarningThreshold = 80;
                    swapCriticalThreshold = 90;
                    diskWarningThreshold = 80;
                    diskCriticalThreshold = 90;
                    diskAvailWarningThreshold = 20;
                    diskAvailCriticalThreshold = 10;
                    batteryWarningThreshold = 20;
                    batteryCriticalThreshold = 5;
                    enableDgpuMonitoring = false;
                    useCustomColors = false;
                    warningColor = "";
                    criticalColor = "";
                    externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
                };
                noctaliaPerformance = {
                    disableWallpaper = true;
                    disableDesktopWidgets = true;
                };
                dock = {
                    enabled = false;
                    position = "bottom";
                    displayMode = "auto_hide";
                    dockType = "floating";
                    backgroundOpacity = 1;
                    floatingRatio = 1;
                    size = 1;
                    onlySameOutput = true;
                    monitors = [];
                    pinnedApps = [];
                    colorizeIcons = false;
                    showLauncherIcon = false;
                    launcherPosition = "end";
                    launcherUseDistroLogo = false;
                    launcherIcon = "";
                    launcherIconColor = "none";
                    pinnedStatic = false;
                    inactiveIndicators = false;
                    groupApps = false;
                    groupContextMenuMode = "extended";
                    groupClickAction = "cycle";
                    groupIndicatorStyle = "dots";
                    deadOpacity = 0.6;
                    animationSpeed = 1;
                    sitOnFrame = false;
                    showDockIndicator = false;
                    indicatorThickness = 3;
                    indicatorColor = "primary";
                    indicatorOpacity = 0.6;
                };
                network = {
                    bluetoothRssiPollingEnabled = false;
                    bluetoothRssiPollIntervalMs = 60000;
                    networkPanelView = "wifi";
                    wifiDetailsViewMode = "grid";
                    bluetoothDetailsViewMode = "grid";
                    bluetoothHideUnnamedDevices = false;
                    disableDiscoverability = false;
                    bluetoothAutoConnect = true;
                };
                sessionMenu = {
                    enableCountdown = true;
                    countdownDuration = 10000;
                    position = "center";
                    showHeader = true;
                    showKeybinds = false;
                    largeButtonsStyle = true;
                    largeButtonsLayout = "single-row";
                    powerOptions = [
                        {
                            action = "lock";
                            command = "";
                            countdownEnabled = true;
                            enabled = true;
                            keybind = "1";
                        }
                        {
                            action = "suspend";
                            command = "";
                            countdownEnabled = true;
                            enabled = true;
                            keybind = "2";
                        }
                        {
                            action = "hibernate";
                            command = "";
                            countdownEnabled = true;
                            enabled = false;
                            keybind = "";
                        }
                        {
                            action = "reboot";
                            command = "";
                            countdownEnabled = true;
                            enabled = true;
                            keybind = "3";
                        }
                        {
                            action = "logout";
                            command = "";
                            countdownEnabled = true;
                            enabled = true;
                            keybind = "4";
                        }
                        {
                            action = "shutdown";
                            command = "";
                            countdownEnabled = true;
                            enabled = true;
                            keybind = "5";
                        }
                        {
                            action = "rebootToUefi";
                            command = "";
                            countdownEnabled = true;
                            enabled = false;
                            keybind = "";
                        }
                        {
                            action = "userspaceReboot";
                            command = "";
                            countdownEnabled = true;
                            enabled = false;
                            keybind = "";
                        }
                    ];
                };
                notifications = {
                    enabled = true;
                    enableMarkdown = false;
                    density = "default";
                    monitors = [
                        "DP-1"
                    ];
                    location = "top_right";
                    overlayLayer = true;
                    backgroundOpacity = 1;
                    respectExpireTimeout = true;
                    lowUrgencyDuration = 3;
                    normalUrgencyDuration = 8;
                    criticalUrgencyDuration = 15;
                    clearDismissed = false;
                    saveToHistory = {
                        low = true;
                        normal = true;
                        critical = true;
                    };
                    sounds = {
                        enabled = false;
                        volume = 0.5;
                        separateSounds = false;
                        criticalSoundFile = "";
                        normalSoundFile = "";
                        lowSoundFile = "";
                        excludedApps = "discord,firefox,chrome,chromium,edge";
                    };
                    enableMediaToast = false;
                    enableKeyboardLayoutToast = false;
                    enableBatteryToast = false;
                };
                osd = {
                    enabled = true;
                    location = "bottom";
                    autoHideMs = 800;
                    overlayLayer = true;
                    backgroundOpacity = 1;
                    enabledTypes = [
                        0
                        3
                    ];
                    monitors = [
                        "DP-1"
                    ];
                };
                audio = {
                    volumeStep = 5;
                    volumeOverdrive = true;
                    spectrumFrameRate = 240;
                    visualizerType = "linear";
                    spectrumMirrored = true;
                    mprisBlacklist = [];
                    preferredPlayer = "";
                    volumeFeedback = false;
                    volumeFeedbackSoundFile = "";
                };
                brightness = {
                    brightnessStep = 1;
                    enforceMinimum = true;
                    enableDdcSupport = false;
                    backlightDeviceMappings = [];
                };
                colorSchemes = {
                    useWallpaperColors = true;
                    predefinedScheme = "Cherry Blossom";
                    darkMode = true;
                    schedulingMode = "off";
                    manualSunrise = "06:30";
                    manualSunset = "18:30";
                    generationMethod = "content";
                    monitorForColors = "";
                    syncGsettings = true;
                };
                templates = {
                    activeTemplates = [];
                    enableUserTheming = false;
                };
                nightLight = {
                    enabled = false;
                    forced = false;
                    autoSchedule = false;
                    nightTemp = "4800";
                    dayTemp = "6500";
                    manualSunrise = "23:30";
                    manualSunset = "01:30";
                };
                hooks = {
                    enabled = false;
                    wallpaperChange = "";
                    darkModeChange = "";
                    screenLock = "";
                    screenUnlock = "";
                    performanceModeEnabled = "";
                    performanceModeDisabled = "";
                    startup = "";
                    session = "";
                    colorGeneration = "";
                };
                plugins = {
                    autoUpdate = false;
                    notifyUpdates = true;
                };
                idle = {
                    enabled = false;
                    screenOffTimeout = 600;
                    lockTimeout = 660;
                    suspendTimeout = 1800;
                    fadeDuration = 5;
                    screenOffCommand = "";
                    lockCommand = "";
                    suspendCommand = "";
                    resumeScreenOffCommand = "";
                    resumeLockCommand = "";
                    resumeSuspendCommand = "";
                    customCommands = "[]";
                };
                desktopWidgets = {
                    enabled = false;
                    overviewEnabled = true;
                    gridSnap = false;
                    gridSnapScale = false;
                    monitorWidgets = [];
                };
            };
        };
    };
}
