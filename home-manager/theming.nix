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

    # inputs.neovim-flake.nixosModules.default

    # Feel free to split up your configuration and import pieces of it here.
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # (import self.inputs.emacs-overlay)

      /*
      (final: prev: {
        catppuccin-kde = final.catppuccin-kde.overrideAttrs (oldAttrs: {
          patches = [];
        });
      })
      */

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    # config = {
    # Disable if you don't want unfree packages
    # allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    # allowUnfreePredicate = _: true;
    # };
  };

  # TODO: Define _all_ themes and icons here
}
