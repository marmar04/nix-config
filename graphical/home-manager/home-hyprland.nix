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

  /*
  home.packages = with pkgs; [
    gtklock
  ];
  */

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    # package = inputs.hyprland.packages.${pkgs.system}.;
    recommendedEnvironment = true;
    systemdIntegration = true;

    # plugins = [inputs.hy3.packages.${pkgs.system}.hy3];

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
      package = pkgs.waybar;
      systemd = {
        enable = true;
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

          modules-left = ["temperature" "memory" "cpu" "wlr/workspaces"];
          modules-center = ["hyprland/window"];
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
            all-outputs = false;
            on-click = "activate";
            on-scroll-up = "${pkgs.hyprland}/bin/hyprctl dispatch workspace e+1";
            on-scroll-down = "${pkgs.hyprland}/bin/hyprctl dispatch workspace e-1";
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
            persistent_workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
            };
          };

          "cpu" = {
            format = "{usage}% ";
            tooltip = false;
          };

          "memory" = {
            format = "{}% ";
          };

          "temperature" = {
            # thermal-zone = 2;
            # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
            critical-threshold = 80;
            format-critical = "{temperatureC}°C {icon}";
            format = "{temperatureC}°C {icon}";
            format-icons = ["󰉬" "" "󰉪"];
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
            format-muted = "󰆪 {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "󰆪 {icon} {format_source}";
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

          "backlight" = {
            format = "{percent}% {icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
          };

          "clock" = {
            format = "{:%Y-%m-%d - %I:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            # on-click = "swaync-client -t -sw";
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
          command = ''${pkgs.gtklock}/bin/gtklock -d -g "adw-gtk3-dark" -S -H -T 30 -b ~/.config/wallpaper/end_cred2.png'';
        }
        {
          timeout = 600;
          command = ''${pkgs.hyprland}/bin/hyprctl dispatch dpms off'';
          resumeCommand = ''${pkgs.hyprland}/bin/hyprctl dispatch dpms on'';
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = ''${pkgs.gtklock}/bin/gtklock -d -g "adw-gtk3-dark" -S -H -T 30 -b ~/.config/wallpaper/end_cred3.png'';
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
