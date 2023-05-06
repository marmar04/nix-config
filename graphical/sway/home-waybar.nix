{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.nix-colors.homeManagerModule];
  programs = {
    waybar = {
      enable = true;

      systemd = {
        enable = true;
        target = "sway-session.target";
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

          modules-left = ["cpu" "memory" "temperature" "custom/seperator" "sway/workspaces"];
          modules-center = ["sway/window"];
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

          "sway/workspaces" = {
            disable-scroll = false;
            disable-markup = false;
            all-outputs = true;
            format = " {icon} ";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "6" = "";
              "focused" = "";
              "default" = "";
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
            format-icons = ["" "" ""];
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

          "backlight" = {
            format = "{percent}% {icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
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
}
