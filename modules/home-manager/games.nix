# For installation of games
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # lutris
    # heroic
    minetest
    unciv
    crawl
    wesnoth
    #mindustry-wayland
  ];
}
