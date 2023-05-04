{xremap, ...}: {
  cfg,
  lib,
  pkgs,
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
      gsettings set $gnome_schema gtk-theme 'Catppuccin-Mocha-Compact-Green-Dark'
      gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    '';
  };

  hyprland-startup = pkgs.writeTextFile {
    name = "hyprland-startup";
    destination = "/bin/hyprland-startup";
    executable = true;
    text = ''
      #!/bin/sh

      cd ~

      export _JAVA_AWT_WM_NONREPARENTING=1
      export XCURSOR_SIZE=24
      # for nvidia
      export LIBVA_DRIVER_NAME=nvidia
      export XDG_SESSION_TYPE=wayland
      export GBM_BACKEND=nvidia-drm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export WLR_NO_HARDWARE_CURSORS=1

      exec Hyprland
    '';
  };
in {
  services = {
    dbus.enable = true;

    gvfs.enable = true;

    tumbler.enable = true;

    # Enable bluetooth via blueman
    blueman.enable = true;

    # To remap CapsLock to Esc for easier vim navigation
    xremap = {
      userName = "marmar";
      config = {
        keymap = [
          {
            name = "caps to escape";
            remap = {
              "CapsLock" = "Esc";
            };
          }
        ];
      };
    };
  };

  programs = {
    # To control backlight (screen brightness)
    light.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    rofi-wayland
    tofi
    fuzzel
    cliphist
    gammastep
    playerctl
    pavucontrol
    pamixer
    # alacritty # gpu accelerated terminal
    # foot
    # shotwell
    wdisplays
    wob
    wf-recorder
    flameshot
    dbus-sway-environment
    configure-gtk
    # waybar
    wayland
    xdg-utils # for openning default programs when clicking links
    glib # gsettings
    swaybg
    swaylock-effects
    # swayidle
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    clipman
    mako # notification system developed by swaywm maintainer
  ];

  # Enable wayland on firefox
  environment = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      # XDG_CURRENT_DESKTOP = "sway";

      # Electron apps use wayland
      NIXOS_OZONE_WL = "1";

      # Use kvantum theming for qt apps
      QT_STYLE_OVERRIDE = "kvantum";
    };
    # etc = {
    #   "pam.d/swaylock" = {
    #     enable = true;
    #     text = "auth include login";
    #   };
    # };
  };

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
