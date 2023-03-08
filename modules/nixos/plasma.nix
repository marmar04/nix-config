# Module to enable the plasma session
{ cfg, lib, pkgs, ... }: {

  services = {
    greetd = {
      enable = true;
      package = pkgs.greetd.tuigreet;
      /*
      settings = {
        command = "/run/current-system/sw/bin/dbus-run-session startplasma-wayland"
      };
      */
    };

    xserver = {
      /*
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      */

      displayManager.defaultSession = "plasmawayland";

      desktopManager.plasma5.enable = true;
    };
  };

  programs = {
    kdeconnect = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
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
  ];

  /*
  xdg = {
    mime = {
      defaultApplications = {
        applications/pdf = "firefox.desktop";
      }
    };
  };
  */
}
