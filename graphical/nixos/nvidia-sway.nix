# Module to enable the plasma session
{
  cfg,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./sway.nix
  ];

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = lib.mkForce "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
        };
      };
    };
  };

  programs = {
    sway = {
      extraOptions = lib.mkForce ["--unsupported-gpu"];
    };
  };
}
