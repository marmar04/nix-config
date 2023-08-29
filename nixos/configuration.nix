# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{programsdb, ...}: {
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    inputs.nh.nixosModules.default

    inputs.nur.nixosModules.nur

    # You can also split up your configuration and import pieces of it here.
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

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      (import inputs.emacs-overlay)

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

      /*
      (self: super: {
        catppuccin-kde = super.catppuccin-kde.override {
          flavour = ["mocha"];
          # accents = ["green"];
        };
      })
      */
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [
        "python-2.7.18.6"
      ];
    };
  };

  # configure nh (nix helper)
  nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
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

      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # FIXME: Add the rest of your current configuration

  security = {
    polkit.enable = true;
  };

  # zram configuration
  zramSwap = {
    enable = true;
    # priority = 10;
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

  # for kvm virtualisation
  virtualisation.libvirtd.enable = true;

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
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  hardware = {
    opengl.enable = true;
    sane = {
      enable = true;
      extraBackends = [pkgs.hplipWithPlugin];
    };

    # Enable bluetooth support
    bluetooth = {
      enable = true;
      settings = {
        General = {
          # to remove errors in journald
          Experimental = true;
          KernelExperimental = true;
        };
      };
    };

    # Disable pulseaudio
    pulseaudio.enable = lib.mkForce false;

    # Enable opentabletdriver
    # opentabletdriver.enable = true;
  };

  # Enable services
  services = {
    kmscon = {
      enable = true;
    };

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

    xserver = {
      # Enable X server
      enable = lib.mkDefault false;

      # digimend.enable = true;

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

      # Configure keymap in X11
      layout = "us";

      displayManager.gdm.enable = lib.mkDefault false;
      displayManager.lightdm.enable = lib.mkDefault false;
    };

    # Have dbus
    dbus.enable = true;

    # Enable printing
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
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

    # Store VS Code auth token
    gnome.gnome-keyring.enable = true;

    # Enable flatpak
    flatpak.enable = true;
  };

  # For flatpak
  system.fsPackages = [pkgs.bindfs];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = ["/share/fonts"];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };

  xdg.portal.enable = true;

  # Fonts
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      # emoji support
      noto-fonts-emoji

      corefonts
      fira-code
      fira
      jetbrains-mono
      fira-code-symbols
      powerline-fonts
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
      source-code-pro

      # for japanese characters to display
      noto-fonts-cjk
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # emacs package
    (pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs-pgtk; # replace with pkgs.emacsPgtk, or another version if desired.
      config = ./../dotfiles/config/emacs/init.el;
      # config = path/to/your/config.org; # Org-Babel configs also supported

      defaultInitFile = true;
      alwaysEnsure = true;

      # Optionally provide extra packages not in the configuration file.
      extraEmacsPackages = epkgs: [
        epkgs.use-package
        epkgs.cask
      ];

      # Optionally override derivations.
      override = epkgs:
        epkgs
        // {
          somePackage = epkgs.melpaPackages.somePackage.overrideAttrs (old: {
            # Apply fixes here
          });
        };
    })
    # themes
    #gradience
    #adw-gtk3
    #catppuccin-kde
    catppuccin-gtk
    catppuccin-kvantum
    papirus-icon-theme
    #fluent-icon-theme
    gnome.adwaita-icon-theme
    # browsers
    virt-manager
    firefox-wayland
    # librewolf-wayland
    microsoft-edge
    tor-browser-bundle-bin
    # communication
    joplin-desktop
    localsend
    keepassxc
    thunderbird-wayland
    tdesktop
    element-desktop-wayland
    calibre
    config.nur.repos.nltch.spotify-adblock
    # download
    persepolis
    transmission-gtk
    czkawka
    # notes
    xournalpp
    # system
    bucklespring-libinput
    glib
    hplip
    easyeffects
    xsane
    # skanlite
    libimobiledevice
    ifuse
    # cli
    alsa-utils
    dash
    coreutils
    lesspipe
    poppler_utils
    epr
    gnuplot
    fortune
    ispell
    curl
    wget
    aria
    nnn
    w3m
    termusic
    pandoc
    tuir
    cht-sh
    moc
    ytfzf
    unzip
    killall
    fd
    ripgrep
    spotdl
    nix-du
    neofetch
    htop
    lolcat
    ncdu
    inxi
    tealdeer
    compsize
    exfat
    networkmanagerapplet
    protonvpn-gui
    # media
    #graphviz
    kdenlive
    gimp
    krita
    inkscape
    darktable
    # rawtherapee
    handbrake
    vlc
    mpv
    #freetube
    gsettings-desktop-schemas
    # coding
    zeal
    #yabasic
    # utilities
    gparted
    libreoffice-qt
    xmind
    cpu-x
  ];

  boot = {
    initrd.systemd.enable = true;
    plymouth.enable = lib.mkDefault false;

    tmp.cleanOnBoot = true;
  };

  programs = {
    # Enabel dconf for gtk theming
    dconf.enable = true;

    # for captive portal (hotel wi-fi)
    captive-browser = {
      enable = true;
      interface = "wlo1";
    };

    # sandboxing apps
    firejail = {
      enable = true;
      wrappedBinaries = {
        google-chrome-stable = {
          executable = "${pkgs.google-chrome}/bin/google-chrome-stable";
          profile = "${pkgs.firejail}/etc/firejail/google-chrome.profile";
          desktop = "${pkgs.google-chrome}/share/applications/google-chrome.desktop";
          extraArgs = [
            "--dbus-user.talk=org.freedesktop.Notifications"
          ];
        };
      };
    };

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

    command-not-found.dbPath = "/etc/programs.sqlite";
  };

  # List environment variables:

  # Enable wayland on firefox
  environment = {
    # Dash is just an example, you can use whatever you want
    binsh = "${pkgs.dash}/bin/dash";
    shells = with pkgs; [fish bash zsh];

    pathsToLink = ["/share/zsh"];

    etc = {
      "programs.sqlite".source = programsdb.packages.${pkgs.system}.programs-sqlite;
    };

    sessionVariables = {
      FLAKE = "/home/marmar/nix-config";
      GTK2_RC_FILES = ''"$XDG_CONFIG_HOME"/gtk-2.0/gtkrc'';
      ELINKS_CONFDIR = ''"$XDG_CONFIG_HOME"/elinks'';
    };
  };

  # qt theming
  qt = {
    enable = true;
    platformTheme = lib.mkDefault "qt5ct";
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  /*
  users.users = {
    # Replace with your username
    # Already in machines subdirectory
    marmar = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" "networkmanager" "audio" "scanner" "lp" ];
    };
  };
  */

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
