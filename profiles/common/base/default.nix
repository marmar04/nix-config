# This is the base config that every system should have installed
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.lix-module.nixosModules.default
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      (import inputs.emacs-overlay)

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      (self: super: {
        colloid-gtk-theme = super.colloid-gtk-theme.override {
          themeVariants = ["green"];
          colorVariants = ["dark"];
          sizeVariants = ["compact"];
          tweaks = ["rimless" "black"];
        };
      })

      (self: super: {
        catppuccin-gtk = super.catppuccin-gtk.override {
          accents = ["green"];
          size = "compact";
          tweaks = ["rimless"];
          variant = "mocha";
        };
      })

      (self: super: {
        catppuccin-kvantum = super.catppuccin-kvantum.override {
          accent = "Green";
          variant = "Mocha";
        };
      })

      # fluent icon theme
      (self: super: {
        fluent-icon-theme = super.fluent-icon-theme.override {
          roundedIcons = true;
          blackPanelIcons = true;
          colorVariants = ["green"];
        };
      })
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-28.3.3"
        "electron-27.3.11"
        "olm-3.2.16"
        "python-2.7.18.6"
        "jitsi-meet-1.0.8043"
      ];
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      substituters = [ "https://ezkea.cachix.org" ];
      trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  security = {
    polkit.enable = true;
  };

  # zram configuration
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 10;
  };

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };
    # Blocklists of websites
    stevenblack = {
      enable = true;
      block = ["fakenews" "gambling" "porn"];
    };
  };

  systemd = {
    # make startup time faster
    services.NetworkManager-wait-online.enable = false;

    tmpfiles = {
      rules = [
        "L+ /lib/${builtins.baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker} - - - - ${pkgs.stdenv.cc.bintools.dynamicLinker}"
        "L+ /lib64 - - - - /lib"
      ];
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
    # For maximum power saving, may not be the most convenient
    # powertop.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  location.provider = "geoclue2";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "en_SG.UTF-8/UTF-8"
      "ms_MY.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_TIME = "en_SG.UTF-8";
      LC_MONETARY = "en_SG.UTF-8";
      LC_TELEPHONE = "en_SG.UTF-8";
      LC_ADDRESS = "en_SG.UTF-8";
      LC_MEASUREMENT = "en_SG.UTF-8";
    };

    #inputMethod = {
      #enable = false;
      #type = "fcitx5";

      #fcitx5 = {
      #  waylandFrontend = true;
      #};
      #ibus = {
      #  engines = with pkgs.ibus-engines; [bamboo libthai typing-booster uniemoji];
      #  panel = "${pkgs.kdePackages.plasma-desktop}/libexec/kimpanel-ibus-panel";
      #};
    #};
  };

  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  hardware = {
    graphics.enable = true;

    sane = {
      enable = true;
      extraBackends = [pkgs.hplipWithPlugin];
    };

    usbStorage.manageShutdown = true;

    # Enable bluetooth support
    bluetooth = {
      enable = true;
      settings = {
        General = {
          # to remove some errors in journald
          Experimental = true;
          KernelExperimental = true;
        };
      };
    };

    steam-hardware.enable = true;

    # Enable opentabletdriver
    # opentabletdriver.enable = true;
  };

  # Enable services
  services = {
    usbmuxd.enable = true;

    thermald.enable = true;

    power-profiles-daemon.enable = lib.mkDefault false;

    upower = {
      enable = true;
    };

    # Enable earlyoom
    earlyoom.enable = true;

    geoclue2 = {
      enable = true;
      enable3G = false;
      enableCDMA = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    xserver = {
      # Enable X server
      enable = lib.mkDefault false;

      # digimend.enable = true;

      # Configure keymap in X11
      xkb.layout = "us";

      displayManager.gdm.enable = lib.mkDefault false;
      displayManager.lightdm.enable = lib.mkDefault false;

      excludePackages = with pkgs; [
        xterm
      ];
    };

    # remapping keys
    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              esc = "capslock";
            };
          };
        };
        #   externalKeyboard = {
        #     ids = [ "1ea7:0907" ];
        #     settings = {
        #       main = {
        #         esc = capslock;
        #       };
        #     };
        #   };
      };
    };

    # Have dbus
    dbus.enable = true;

    # Enable printing
    printing = {
      enable = true;
      allowFrom = ["all"];
      drivers = with pkgs; [hplip];
    };

    # Enable sound with pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # for security credentials
    gnome.gnome-keyring.enable = true;

    tailscale = {
      enable = true;
    };

    # for tor network
    privoxy = {
      enable = true;
      enableTor = true;
    };
    tor = {
      enable = true;
      client.enable = true;
      torsocks.enable = true;
    };
  };

  # Fonts
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      corefonts
      vistafonts
      #liberation_ttf
      eb-garamond
      lato
      monocraft #gamification
      fira-code
      fira
      fira-code-symbols
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono
      source-code-pro
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    emacs
    #(pkgs.emacsWithPackagesFromUsePackage {
    #  package = pkgs.emacs; # replace with pkgs.emacsPgtk, or another version if desired.
    #  config = ./../../../dotfiles/config/emacs/init.el;
    #  # config = path/to/your/config.org; # Org-Babel configs also supported

    #  defaultInitFile = true;
    #  alwaysEnsure = true;

    #  # Optionally provide extra packages not in the configuration file.
    #  extraEmacsPackages = epkgs: [
    #    epkgs.use-package
    #  ];
    #})
    # broken for now
    #inputs.nvix.packages.${system}.default
    # cpp
    codeblocks
    gdb
    clang
    clang-tools
    gnumake
    # system
    pass-wayland
    bucklespring-libinput
    byobu
    glib
    hplip
    easyeffects
    #xsane
    # skanlite
    libimobiledevice
    ifuse
    # cli clients
    toot
    iamb
    neomutt
    # cli
    coreutils
    gnuplot
    fortune
    ispell
    curl
    wget
    aria
    w3m
    pandoc
    tuir
    cht-sh
    ytfzf
    porsmo # pomodoro timer
    unzip
    killall
    fd
    ripgrep
    #spotdl
    nix-du
    neofetch
    fastfetch
    htop
    ncdu
    inxi
    tealdeer
    #compsize
    distrobox
    # coding
    zeal
  ];

  boot = {
    initrd.systemd.enable = true;
    plymouth.enable = lib.mkDefault false;

    tmp.cleanOnBoot = true;
  };

  programs = {
    # configure nh (nix helper)
    nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
    };

    mosh.enable = true;

    tmux = {
      enable = true;
      clock24 = true;
      terminal = "screen-256color";
      # make it like byobu
      shortcut = "a";
      keyMode = "vi";
      escapeTime = 0;
      customPaneNavigationAndResize = true;

      plugins = with pkgs.tmuxPlugins; [catppuccin];
    };

    screen.enable = true;

    usbtop.enable = true;

    command-not-found.dbPath = "/etc/programs.sqlite";
  };

  # List environment variables:

  # Enable wayland on firefox
  environment = {
    localBinInPath = true;

    # Dash is just an example, you can use whatever you want
    binsh = "${pkgs.dash}/bin/dash";
    shells = with pkgs; [fish bash zsh];

    pathsToLink = ["/share/zsh"];

    variables = {
      EDITOR = "emacsclient -nw";
      VISUAL = "emacsclient -c";
    };

    sessionVariables = {
      NH_FLAKE = "/home/marmar/nix-config";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
