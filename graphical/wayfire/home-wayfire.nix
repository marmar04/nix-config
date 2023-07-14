{pkgs, ...}: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule

    # Feel free to split up your configuration and import pieces of it here.
  ];

  services = {
    # overlay bar
    avizo = {
      enable = true;
    };

    # idle management
    /*
    swayidle = {
      enable = true;
      systemdTarget = "session.target";
      timeouts = [
        {
          timeout = 300;
          command = ''${pkgs.gtklock}/bin/gtklock -d -g "Catppuccin-Mocha-Compact-Green-Dark" -S -H -T 30 -b ~/.config/wallpaper/end_cred2.png'';
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
          command = ''${pkgs.gtklock}/bin/gtklock -d -g "Catppuccin-Mocha-Compact-Green-Dark" -S -H -T 30 -b ~/.config/wallpaper/end_cred3.png'';
        }
        # { event = "lock"; command = "lock"; }
      ];
    };
    */
  };
}
