{
  pkgs,
  lib,
  inputs,
  ...
}: let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Breeze-Dark'
      gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    '';
  };
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # to import home-manager modules
  home-manager.sharedModules = [
    ./home-wlroots.nix
  ];

  fonts = {
    fontconfig.defaultFonts = {
      monospace = ["JetBrains Mono"];
    };
  };

  services = {
    dbus.enable = true;

    gvfs.enable = true;

    tumbler.enable = true;

    # Enable blueman to access bluetooth
    blueman.enable = true;
  };

  programs = {
    # To control backlight
    light.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  # Soma packages
  environment.systemPackages =
    (with pkgs; [
      systemsettings
      breeze-qt5
      breeze-gtk

      alsa-utils
      lesspipe
      proppler_utils
      epr
      tofi
      cliphist
      gammastep
      playerctl
      pavucontrol
      pamixer
      # alacritty # gpu accelerated terminal
      wdisplays
      wf-recorder
      flameshot
      dbus-sway-environment
      configure-gtk
      xdg-utils # for openning default programs when clicking links
      glib # gsettings
      swaybg
      swaylock-effects
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      clipman
      mako # notification system developed by swaywm maintainer

      # socials
      nheko
      gajim
      tokodon

      # qt apps
      kristall
      minitube
    ])
    ++ (with pkgs.kdePackages; [
      falkon
      kasts
      elisa
    ]);

  # Enable wayland on firefox
  environment = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      # XDG_CURRENT_DESKTOP = "sway";

      # Electron apps use wayland
      NIXOS_OZONE_WL = "1";

      # Use kvantum theming for qt apps
      # QT_STYLE_OVERRIDE = "kvantum";
    };
  };

  security = {
    pam.services = {
      swaylock = {};
      gtklock = {};
    };
  };

  qt.platformTheme = lib.mkForce "kde";

  xdg = {
    mime = {
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "text/org" = "emacsclient.desktop";

        "applications/pdf" = "zathura.desktop";
        "application/epub+zip" = "zathura.desktop";

        "video/webm" = "mpv.desktop";
      };
    };
  };
}
