# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  inputs,
  cfg,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./../common/wlroots
  ];

  home-manager.sharedModules = [
    ./home-sway.nix
    ./home-waybar.nix
  ];

  # for swaylock to work
  security = {
    pam.services = {
      swaylock = {};
    };
  };

  # for greeter
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };

    # remapping keys
    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              esc = "capslock";
            };
          };
        };
        #   externalKeyboard = {
        #     ids = [ "1ea7:0907" ];
        #     settings = {
        #       main = {
        #         esc = capslock;
        #       };
        #     };
        #   };
      };
    };
  };

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
