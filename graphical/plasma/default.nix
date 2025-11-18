# Module to enable the plasma session
{
  cfg,
  lib,
  pkgs,
  ...
}: {
  services = {
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

    desktopManager.plasma6.enable = true;

    xserver.enable = lib.mkForce true;

    power-profiles-daemon.enable = true;
  };

  programs = {
    kdeconnect = {
      enable = true;
    };

    gnupg.agent.enable = true;
  };

  environment.systemPackages =
    (with pkgs; [
      gsettings-desktop-schemas

      # socials
      element-desktop
      vesktop
      nextcloud-client

      (vivaldi.overrideAttrs
        (oldAttrs: {
          dontWrapQtApps = false;
          dontPatchELF = true;
          nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.kdePackages.wrapQtAppsHook];
        }))
      digikam
    ])
    ++ (with pkgs.kdePackages; [
      ocean-sound-theme
      oxygen-sounds

      kcharselect
      kgpg
      kbackup
      skanlite
      #kmail
      tokodon
      konversation

      kalarm
      ktimer
      filelight

      arianna
      kcalc
      kasts
      krecorder
      alligator
      akregator
      kate
      calligra
      #neochat
      kleopatra
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
