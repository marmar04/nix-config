{ nixpkgs-unstable, ... }:
{ config, pkgs, ... }:
let
 overlay-unstable = final: prev: {
   unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
 };
in
{
   nixpkgs.overlays = [ overlay-unstable ];
   environment.systemPackages = with pkgs; [
     unstable.catppuccin-kde
     (unstable.catppuccin-gtk.override {
       accents = [ "green" ];
       variant = "mocha";
     })
     # unstable.qutebrowser
     # unstable.colloid-kde
     # unstable.colloid-gtk-theme
     # unstable.colloid-icon-theme
  ];
}
