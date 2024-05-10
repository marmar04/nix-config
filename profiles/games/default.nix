{ inputs, pkgs, config, ... }:
{
  imports = [
    inputs.aagl.nixosModules.default
  ];

  # blocks mihoyo telemetry when playing :D
  networking.mihoyo-telemetry.block = true;

  programs = {
    # Adds launcher and /etc/hosts rules
    anime-games-launcher.enable = true;
  };

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    lutris
    minetest
    superTuxKart
    katawa-shoujo
    freeciv_qt
    #vinegar
    #mindustry-wayland
  ];
}
