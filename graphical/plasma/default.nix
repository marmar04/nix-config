# Module to enable the plasma session
{
  cfg,
  lib,
  pkgs,
  ...
}: {
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd startplasma-wayland";
          user = "greeter";
        };
      };
    };

    xserver = {
      /*
      displayManager.gdm = {
        enable = lib.mkForce true;
        wayland = true;
        defaultSession = "plasmawayland";
      };
      */

      desktopManager.plasma5 = {
        enable = true;
        runUsingSystemd = false;
      };
    };
  };

  programs = {
    kdeconnect = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    #plasma5Packages.bismuth
    arianna

    wl-clipboard
    libsForQt5.kamoso
    komikku

    gsettings-desktop-schemas

    # socials
    nheko
    kaidan
    abaddon

    falkon
    kup
    digikam
    neochat
    tokodon
    kcalc
    kate
    rsibreak
    libsForQt5.krecorder
  ];

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
    extraPortals = [pkgs.plasma5Packages.xdg-desktop-portal-kde];
  };
}
