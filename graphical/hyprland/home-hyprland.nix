{
  config,
  lib,
  pkgs,
  inputs,
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
    # package = inputs.hyprland.packages.${pkgs.system}.;
    recommendedEnvironment = true;
    systemdIntegration = true;

    # plugins = [inputs.hy3.packages.${pkgs.system}.hy3];

    extraConfig = builtins.readFile ./../../dotfiles/config/hypr/hyprland.conf;
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
}
