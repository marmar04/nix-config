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
      enable = true;
      desktopManager.plasma5.enable = true;
    };
  };

  programs = {
    kdeconnect = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    plasma5Packages.bismuth

    wl-clipboard
    foot
    libsForQt5.kamoso
    komikku

    digikam
    neochat
    kcalc
    kate
    rsibreak
    libsForQt5.krecorder
    libsForQt5.audiotube
    libsForQt5.plasmatube
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
      # QT_STYLE_OVERRIDE = "kvantum";
    };
  };
}
