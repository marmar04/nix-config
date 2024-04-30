{ inputs, pkgs, config, ... }:
{
  imports = [
    inputs.aagl.nixosModules.default
  ];

  networking.mihoyo-telemetry.block = true;

  programs = {
    anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules
    anime-games-launcher.enable = true;
    anime-borb-launcher.enable = true;
    honkers-railway-launcher.enable = true;
    honkers-launcher.enable = true;
  };

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    #docker-compose # start group of containers for dev
    podman-compose  # start group of containers for dev
  ];
}
