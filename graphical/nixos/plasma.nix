# Module to enable the plasma session
{xremap, ...}: {
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
        enable = true;
        wayland = true;
      };
      */
      desktopManager.plasma5.enable = true;
    };

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
    kdeconnect = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    foot
    libsForQt5.kamoso
    # latte-dock
    digikam
    neochat
    kcalc
    kate
    rsibreak
    libsForQt5.krecorder
    libsForQt5.audiotube
    libsForQt5.plasmatube
    # sddm-kcm
    libsForQt5.kio-gdrive
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
  };
}
