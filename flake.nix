{
  # check out vim tags for easier navigation
  description = "My nixos configuration for an optimus laptop";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-doom-emacs,
    hyprland,
    nur,
    xremap,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in rec {
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./pkgs {inherit pkgs;});
    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    /*
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );
    */

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays;
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      # replace with your hostname
      roguenix = nixpkgs.lib.nixosSystem {
        # Note that you cannot put arbitrary configuration here: the configuration must be placed in the files loaded via modules
        specialArgs = {
          inherit inputs outputs;
        }; # Pass flake inputs to our config
        modules =
          (builtins.attrValues nixosModules)
          ++ [
            hyprland.nixosModules.default
            xremap.nixosModules.default
            # > Our main nixos configuration file <
            ./nixos/configuration.nix
            ./machines/roguenix/nixos/configuration.nix
            # (import ./unstable/unstable.nix inputs)

            ./graphical/nvidia-sway-hyprland.nix
            # ./graphical/nixos/nvidia-sway.nix
            (import ./graphical/nixos/wlroots.nix inputs)
            ./graphical/nixos/nvidia-sway.nix
            (import ./graphical/nixos/nvidia-hyprland.nix inputs)
            # Our common nixpkgs config (unfree, overlays, etc)
            (import ./nixpkgs-config.nix {inherit overlays;})
          ];
      };

      elitenix = nixpkgs.lib.nixosSystem {
        # Note that you cannot put arbitrary configuration here: the configuration must be placed in the files loaded via modules
        specialArgs = {
          inherit inputs outputs;
        }; # Pass flake inputs to our config
        modules =
          (builtins.attrValues nixosModules)
          ++ [
            hyprland.nixosModules.default
            xremap.nixosModules.default
            # > Our main nixos configuration file <
            ./nixos/configuration.nix
            ./machines/elitenix/nixos/configuration.nix
            # (import ./unstable/unstable.nix inputs)

            ./graphical/sway-hyprland.nix
            # ./graphical/nixos/nvidia-sway.nix
            (import ./graphical/nixos/wlroots.nix inputs)
            ./graphical/nixos/sway.nix
            (import ./graphical/nixos/hyprland.nix inputs)
            ./graphical/nixos/sway.nix
            # Our common nixpkgs config (unfree, overlays, etc)
            (import ./nixpkgs-config.nix {inherit overlays;})
          ];
      };

      oldnix = nixpkgs.lib.nixosSystem {
        # Note that you cannot put arbitrary configuration here: the configuration must be placed in the files loaded via modules
        specialArgs = {
          inherit inputs outputs;
        }; # Pass flake inputs to our config
        modules =
          (builtins.attrValues nixosModules)
          ++ [
            # > Our main nixos configuration file <
            ./nixos/configuration.nix
            ./machines/oldnix/nixos/configuration.nix

            ./graphical/nixos/plasma.nix
            # Our common nixpkgs config (unfree, overlays, etc)
            (import ./nixpkgs-config.nix {inherit overlays;})
          ];
      };
    };

    homeConfigurations = {
      # replace with your username@hostname
      "marmar@roguenix" = home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
        }; # Pass flake inputs to our config
        modules =
          (builtins.attrValues homeManagerModules)
          ++ [
            # > Our main home-manager configuration file <
            ./home-manager/home.nix
            ./graphical/home-manager/home-wlroots.nix
            ./graphical/home-manager/home-sway.nix
            ./graphical/home-manager/home-hyprland.nix
            # Our common nixpkgs config (unfree, overlays, etc)
            (import ./nixpkgs-config.nix {inherit overlays;})
          ];
      };

      "marmar@elitenix" = home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
        }; # Pass flake inputs to our config
        modules =
          (builtins.attrValues homeManagerModules)
          ++ [
            /*
            home-manager.nixosModules.home-manager
            {
              home-manager.users.exampleUser = {...}: {
                imports = [nix-doom-emacs.hmModule];
                programs.doom-emacs = {
                  enable = true;
                  doomPrivateDir = ./dotfiles/config/doom.d; # Directory containing your config.el, init.el
                  # and packages.el files
                };
              };
            }
            */
            # > Our main home-manager configuration file <
            ./home-manager/home.nix
            ./graphical/home-manager/home-wlroots.nix
            ./graphical/home-manager/home-sway.nix
            ./graphical/home-manager/home-hyprland.nix
            # Our common nixpkgs config (unfree, overlays, etc)
            (import ./nixpkgs-config.nix {inherit overlays;})
          ];
      };
      "marmar@oldnix" = home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
        }; # Pass flake inputs to our config
        modules =
          (builtins.attrValues homeManagerModules)
          ++ [
            # > Our main home-manager configuration file <
            ./home-manager/home.nix
            # Our common nixpkgs config (unfree, overlays, etc)
            (import ./nixpkgs-config.nix {inherit overlays;})
          ];
      };
    };
  };
}
