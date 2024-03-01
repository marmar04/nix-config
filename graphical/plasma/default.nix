# Module to enable the plasma session
{
  cfg,
  lib,
  pkgs,
  ...
}: {
  services = {
    xserver = {
      enable = lib.mkForce true;

      displayManager = {
        defaultSession = "plasmawayland";

        sddm = {
          enable = true;
          autoNumlock = true;
          settings = {
            # run sddm in wayland
            General = {
              DisplayServer = "wayland";
              #GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
            };
            #Wayland = {
            #  CompositorCommand = "kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1";
            #};

            # enables autologin
            Autologin = {
              User = "marmar";
              Session = "plasmawayland";
            };
          };
        };
      };

      desktopManager.plasma5 = {
        enable = true;
      };
    };
    power-profiles-daemon.enable = true;
  };

  programs = {
    kdeconnect = {
      enable = true;
    };
  };

  environment.systemPackages =
    (with pkgs; [
      westonLite

      wl-clipboard

      gsettings-desktop-schemas

      # socials
      nheko
      kaidan
      konversation
      tokodon

      falkon
      kristall
      arianna
      minitube
      kup
      digikam
      kcalc
      kate
      ktimetracker
      rsibreak
    ])
    ++ (with pkgs.libsForQt5; [
      kamoso
      kasts
      krecorder
      alligator
      neochat
      plasmatube
      audiotube
    ]);

  # Enable wayland on firefox
  environment = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";

      # Electron apps use wayland
      #NIXOS_OZONE_WL = "1";

      # WARNING: breaks gtk theming and cursor size
      # use kde filepicker when available
      #GTK_USE_PORTAL = "1";
    };
  };

  qt.platformTheme = lib.mkForce "kde";

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = ["kde"];
      };
    };
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.plasma5Packages.xdg-desktop-portal-kde];
  };
}
