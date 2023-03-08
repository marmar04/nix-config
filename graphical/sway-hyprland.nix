{
  cfg,
  lib,
  pkgs,
  ...
}:
{
  services = {
    # To start up tuigreet and set it up to start up hyprland after loging in
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = lib.mkForce "${pkgs.greetd.tuigreet}/bin/tuigreet --time --greeting 'Access is restricted to authorized personnel only\nUse Hypr command to launch Hyprland' --cmd sway";
          user = "greeter";
        };
      };
    };
  };
}
