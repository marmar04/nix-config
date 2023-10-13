{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;

    #iconTheme.name = "Adwaita";
    #theme.name = "adw-gtk3-dark";

    #gtk3.extraConfig = {
    #  gtk-application-prefer-dark-theme = 1;
    #};

    #gtk4.extraConfig = {
    #  gtk-application-prefer-dark-theme = 1;
    #};
  };

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = lib.hm.gvariant.mkUint32 2450;
    };

    "org/gnome/system/location".enabled = true;

    "org/gnome/desktop/session".idle-delay = lib.hm.gvariant.mkUint32 300;

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "Adwaita";
      clock-show-date = true;
      clock-show-weekday = true;
      gtk-theme = "adw-gtk-dark";
      icon-theme = "Adwaita";
      font-name = "Cantarell 11";
      document-font-name = "Cantarell 11";
      monospace-font-name = "JetBrainsMono Nerd Font 10";
    };
    "org/gnome/desktop/calendar".show-weekdate = true;

    # background
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
      primary-color = "#241f31";
      secondary-color = "#000000";
    };
    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
      primary-color = "#241f31";
      secondary-color = "#000000";
      # lockscreen
      lock-enabled = true;
      lock-delay = lib.hm.gvariant.mkUint32 30;
    };

    "org/gnome/desktop/datetime".automatic-timezone = true;
    "org/gtk/settings/file-chooser".clock-format = "24h";

    "org/gnome/desktop/notifications".show-banners = true;
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "adaptive";
      speed = 1.0;
      natural-scroll = true;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      disable-while-typing = true;
      speed = 1.0;
      click-method = "fingers";
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
      natural-scroll = true;
    };

    "org/gnome/mutter".dynamic-workspaces = true;

    "org/gnome/desktop/input-sources".xkb-options = ["lv3:menu_switch"];
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Shift><Alt>q"];
      show-desktop = ["<Super>d"];
      move-to-workspace-1 = ["<Shift><Alt>1"];
      move-to-workspace-2 = ["<Shift><Alt>2"];
      move-to-workspace-3 = ["<Shift><Alt>3"];
      move-to-workspace-4 = ["<Shift><Alt>4"];
      switch-to-workspace-1 = ["<Alt>1"];
      switch-to-workspace-2 = ["<Alt>2"];
      switch-to-workspace-3 = ["<Alt>3"];
      switch-to-workspace-4 = ["<Alt>4"];
    };
    "org/gnome/desktop/wm/preferences".button-layout = "appmenu:close";

    # favourite apps
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Music.desktop"
        "org.gnome.Photos.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "emacsclient.desktop"
      ];

      disable-user-extensions = false;
      enabled-extensions = [
        "pomodoro@arun.codito.in"
        "gsconnect@andyholmes.github.io"
        "clipboard-indicator@tudmotu.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "just-perfection-desktop@just-perfection"
      ];
    };

    # other apps
    "com/github/huluti/Curtail" = {
      dark-theme = true;
      webp-lossless-level = 6;
      png-lossless-level = 7;
    };
  };
}
