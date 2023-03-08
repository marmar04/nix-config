# Module to enable the plasma session
{
  cfg,
  lib,
  pkgs,
  ...
}: let
  sway-nvidia-wrapper = pkgs.writeTextFile {
    name = "sway-nvidia-wrapper";
    destination = "/bin/sway-nvidia-wrapper";
    executable = true;

    text = ''
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway

      exec sway --unsupported-gpu $@
    '';
  };
in {
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
          user = "greeter";
        };
      };
    };
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = ["--unsupported-gpu"];
    };
  };

  environment.systemPackages = with pkgs; [
    sway-nvidia-wrapper
  ];

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # Enable wayland on firefox
  environment = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
    };
  };
}
