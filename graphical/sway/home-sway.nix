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

    inputs.nix-colors.homeManagerModule

    # Feel free to split up your configuration and import pieces of it here.
  ];

  # Catppuccin mocha for colour
  # TODO: change with own everforest base 16 theme
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  home.packages = with pkgs; [
    sway-contrib.grimshot
  ];

  # swayidle config
  services = {
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.swaylock-effects}/bin/swaylock -f --clock -i ~/.config/wallpaper/end_cred2.png";
        }
        {
          timeout = 600;
          command = ''${pkgs.sway}/bin/swaymsg "output * power off"'';
          resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * power on"'';
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

    # overlay bar
    avizo = {
      enable = true;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      startup = [
        /*
        {
          command = "systemctl --user restart waybar";
          always = true;
        }
        */
        {command = "configure-gtk";}
        {command = "foot --server";}
        {command = "nm-applet --indicator";}
        {command = "gammastep-indicator -l 2.9:101.6";}
        {command = "blueman-applet";}
      ];

      # Default terminal
      terminal = "${pkgs.foot}/bin/footclient";

      assigns = {
        "3" = [{class = "Emacs";}];
        "5" = [
          {app_id = "discord";}
        ];
      };

      colors = {
        focused = {
          background = "#3a515d";
          border = "#a6e3a1";
          childBorder = "#a6e3a1";
          indicator = "#a6e3a1";
          text = "#d3c6aa";
        };
      };

      bars = [
        # {command = "${pkgs.waybar}/bin/waybar";}
      ];

      fonts = {
        names = ["JetBrains Mono" "Sans-Serif"];
        # style = "Bold Semi-Condensed";
        size = 11.0;
      };

      gaps.outer = 5;

      modifier = "Mod1";

      menu = "${pkgs.fuzzel}/bin/fuzzel";

      input = {
        "type:keyboard" = {
          xkb_numlock = "enabled";
        };

        "type:touchpad" = {
          natural_scroll = "enabled";
          pointer_accel = "1";
          accel_profile = "adaptive";
          dwt = "enabled";
          tap = "enabled";
        };

        "type:pointer" = {
          natural_scroll = "enabled";
          pointer_accel = "1";
          accel_profile = "adaptive";
        };
      };

      output = {
        # most screens
        eDP-1 = {
          bg = "~/.config/wallpaper/changing_at_the_edge_of_the_world_final_shot.jpg fill";
        };

        # for elitenix
        LVDS-1 = {
          bg = "~/.config/wallpaper/changing_at_the_edge_of_the_world_final_shot.jpg fill";
        };
      };

      seat = {
        "*" = {
          hide_cursor = "when-typing enable";
        };
      };

      floating = {
        titlebar = false;
        criteria = [
          {app_id = "pavucontrol";}
          {app_id = "nm-connection-editor";}
          {title = "Bluetooth Devices";}
          {title = "Firefox — Sharing Indicator";}
          {title = "File Operation Progress";}
          {title = "Instant messaging status";}
        ];
      };

      window.commands = [
        {
          command = "inhibit_idle fullscreen";
          criteria.app_id = "firefox";
        }
        {
          command = "inhibit_idle fullscreen";
          criteria.class = "Microsoft-edge";
        }
        {
          command = "inhibit_idle fullscreen";
          criteria.app_id = "mpv";
        }
        {
          command = "inhibit_idle fullscreen";
          criteria.class = "firefox";
        }
        {
          command = "inhibit_idle focus";
          criteria.class = "FreeTube";
        }
        {
          command = "inhibit_idle focus";
          criteria.class = "vlc";
        }
        {
          command = "fullscreen enable";
          criteria.app_id = "calibre-ebook-viewer";
        }
      ];

      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
        inherit
          (config.wayland.windowManager.sway.config)
          left
          down
          up
          right
          menu
          terminal
          ;
      in {
        "${mod}+Return" = "exec ${terminal}";
        "${mod}+Shift+q" = "kill";
        "${mod}+space" = "exec ${menu}";
        # "--release Super_L" = "exec pkill fuzzel || ${menu}";

        "${mod}+${left}" = "focus left";
        "${mod}+${down}" = "focus down";
        "${mod}+${up}" = "focus up";
        "${mod}+${right}" = "focus right";

        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        "${mod}+Shift+${left}" = "move left";
        "${mod}+Shift+${down}" = "move down";
        "${mod}+Shift+${up}" = "move up";
        "${mod}+Shift+${right}" = "move right";

        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        "${mod}+Shift+space" = "floating toggle";
        "${mod}+Shift+t" = "focus mode_toggle";

        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        "${mod}+b" = "split h";
        "${mod}+v" = "split v";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+a" = "focus parent";
        "${mod}+z" = "focus child";

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = ''mode "system:  [r]eboot  [p]oweroff  [l]ogout"'';
        # For emacs-everywhere
        # "${mod}+Shift+e" = ''exec emacsclient --eval "(emacs-everywhere)"'';

        "${mod}+r" = "mode resize";

        "Mod4+l" = "exec ${pkgs.swaylock-effects}/bin/swaylock -f --clock -i ~/.config/wallpaper/end_cred1.png";
        # "${mod}+k" = "exec ${pkgs.mako}/bin/makoctl dismiss";
        # "${mod}+Shift+k" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

        "${mod}+apostrophe" = "move workspace to output right";

        "${mod}+minus" = "scratchpad show";
        "${mod}+underscore" = "move container to scratchpad";

        # For screenshots with grimshot
        "Mod4+p" = "grimshot --notify copy output";
        "Mod4+Shift+p" = ''grimshot --notify save output screenshot$(date +"%FT%H%M%S-%N").png'';
        "Print" = "grimshot --notify copy area";
        "${mod}+Mod4+Shift+p" = ''grimshot --notify save area screenshot$(date +"%FT%H%M%S-%N").png'';
      };
    };

    extraOptions = ["--unsupported-gpu"];

    # systemdIntegration = true;
    systemd.enable = true;

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';

    extraConfig = ''
      seat seat0 xcursor_theme Adwaita 24

      # Allow switching between workspaces with left and right swipes
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next

      # Set up cliphist
      exec cliphist wipe
      exec wl-paste --watch cliphist store &
      bindsym Mod1+Shift+p exec cliphist list | fuzzel -d | cliphist decode | wl-copy
      bindsym Mod1+Shift+d exec cliphist list | fuzzel -d | cliphist delete

      # Binding keys to functions
      # bindsym XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindsym --locked XF86AudioPlay exec playerctl play-pause
      bindsym --locked XF86AudioNext exec playerctl next
      bindsym --locked XF86AudioPrev exec playerctl previous
      bindsym XF86Search exec $menu
      bindsym XF86Display exec wdisplays
      bindsym XF86AudioRaiseVolume exec volumectl -u up
      bindsym XF86AudioLowerVolume exec volumectl -u down
      bindsym XF86AudioMute exec volumectl toggle-mute
      bindsym XF86AudioMicMute exec volumectl -m toggle-mute

      bindsym XF86MonBrightnessUp exec lightctl up
      bindsym XF86MonBrightnessDown exec lightctl down

      # to start on workspace 1
      workspace 1
    '';
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
