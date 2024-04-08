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
        defaultSession = "plasma";

        sddm = {
          enable = true;
          wayland.enable = true;
          autoNumlock = true;
          settings = {
            Theme = {
              CursorTheme = "Breeze";
              CursorSize = 24;
            };
            # enables autologin
            Autologin = {
              User = "marmar";
              Session = "plasma";
            };
          };
        };
      };

      desktopManager.plasma6 = {
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
      gsettings-desktop-schemas
      gnupg

      # socials
      nheko
      kaidan
      teams-for-linux

      kristall
      minitube
      digikam
    ])
    ++ (with pkgs.kdePackages; [
      kcharselect
      kgpg
      skanlite
      #kamoso
      tokodon
      konversation

      kalarm
      ktimer

      arianna
      falkon
      kcalc
      kasts
      krecorder
      alligator
      akregator
      kate
      neochat
      kleopatra
      plasmatube
      audiotube
    ]);

  # Enable wayland on firefox
  environment = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";

      # Electron apps use wayland
      NIXOS_OZONE_WL = "1";

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
    extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];
  };
}
