# This is the base config that every system should have installed
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # For jupyter notebooks (jupyter lab)
    (python3.withPackages (ps: with ps; [
      numpy # these two are
      scipy # probably redundant to pandas
      seaborn
      sklearn-compat
      kneed
      matplotlib
      jupyterlab
      pandas
      statsmodels
      scikit-learn
      scikit-image
    ]))
  ];
}
