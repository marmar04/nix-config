# This is the base config that every system should have installed
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    octaveFull
  ];
}
