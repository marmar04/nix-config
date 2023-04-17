# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule

    inputs.hyprland.homeManagerModules.default

    # Feel free to split up your configuration and import pieces of it here.
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    recommendedEnvironment = true;
    systemdIntegration = true;

    extraConfig = builtins.readFile ./../../dotfiles/config/hypr/hyprland.conf;
  };

  programs = {
    eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./../../dotfiles/config/eww;
    };

    waybar = {
      enable = true;
      package = inputs.hyprland.packages.x86_64-linux.waybar-hyprland;
      systemd = {
        enable = false;
        target = "hyprland-session.target";
      };
      style = ./../../dotfiles/config/waybar/style.css;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 42;
          margin-left = 2;
          margin-right = 2;
          spacing = 2;

          modules-left = ["custom/search" "custom/separator" "wlr/workspaces" "custom/separator" "hyprland/window"];
          modules-right = ["idle_inhibitor" "tray" "pulseaudio" "backlight" "battery" "clock"];

          "custom/search" = {
            tooltip = false;
            format = " ";
            on-click = "killall fuzzel || fuzzel";
          };

          "custom/separator" = {
            format = "|";
            interval = "once";
            tooltip = false;
          };

          "wlr/workspaces" = {
            disable-scroll = true;
            disable-markup = false;
            all-outputs = true;
            on-click = "activate";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            format = " {icon} ";
            format-icons = {
              "1" = "  ";
              "2" = "  ";
              "3" = "  ";
              "4" = "  ";
              "5" = "  ";
              "6" = "  ";
              "focused" = "  ";
              "default" = "  ";
            };
            /*
            persistent_workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
            };
            */
          };

          "hyprland/window" = {
            format = " {} ";
          };

          "wlr/taskbar" = {
            format = " {icon} {title} ";
            icon-size = 14;
            icon-theme = "Papirus-Dark";
            tooltip-format = "{app_id}";
            on-click = "activate";
            on-click-middle = "close";
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              "activated" = "";
              "deactivated" = "";
            };
          };

          "tray" = {
            spacing = 10;
          };

          "battery" = {
            states = {
              "good" = 95;
              "warning" = 30;
              "critical" = 15;
            };
            format = "{capacity}% {icon}";
            tooltip-format = "{timeTo}, {capacity}";
            format-alt = "{time} {icon}";
            format-icons = ["" "" "" "" ""];
          };

          "pulseaudio" = {
            format = "{volume}% {icon} {format_source}";
            format-muted = " {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            ignored-sinks = ["Easy Effects Sink"];
            format-icons = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["" "" ""];
            };
            on-click = "pavucontrol";
          };

          "clock" = {
            format = "{:%Y-%m-%d - %I:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            on-click = "swaync-client -t -sw";
          };
        };
      };
    };
  };

  services = {
    swayidle = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.swaylock-effects}/bin/swaylock -f --clock -i ~/.config/wallpaper/end_cred2.png";
        }
        {
          timeout = 600;
          command = ''hyprctl dispatch dpms off'';
          resumeCommand = ''hyprctl dispatch dpms on'';
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock-effects}/bin/swaylock -f --clock -i ~/.config/wallpaper/end_cred3.png";
        }
        # { event = "lock"; command = "lock"; }
      ];
    };
  };

  # For linking the files in config folder
  xdg = {
    configFile = {
      "hypr/mocha.conf" = {
        source = ./../../dotfiles/config/hypr/mocha.conf;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
