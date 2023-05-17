# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./../common/wlroots

    ./sway.nix
  ];

  home-manager.sharedModules = [
    ./home-sway.nix
    ./home-waybar.nix
  ];
}
