{
  # check out vim tags for easier navigation
  description = "My nixos configuration for an optimus laptop";

  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };

    /*
    neovim-flake = {
      url = "github:notashelf/neovim-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nil.follows = "nil";
        flake-utils.follows = "flake-utils";
      };
    };
    */

    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    /*
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    */

    # Remap keys
    xremap = {
      url = "github:xremap/nix-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprland.follows = "hyprland";
      };
    };

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix User Repository
    nur = {
      url = "github:nix-community/NUR";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # Nix Language server
    nil = {
      url = "github:oxalica/nil";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-utils.follows = "flake-utils";
      };
    };

    # For command-not-found
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    # Anyrun launcher (for wayland)
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swayosd = {
      url = "github:marmar04/SwayOSD";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    neovim-flake,
    kmonad,
    programsdb,
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

    # Formatter
    # Can be accessed through nix fmt
    formatter = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.alejandra
    );

    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    # devShells = forAllSystems (
    #   system: let
    #     pkgs = nixpkgs.legacyPackages.${system};
    #   in
    #     import ./shell.nix {inherit pkgs;}
    # );

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
            kmonad.nixosModules.default

            # home-manager module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.users.marmar.imports =
                (builtins.attrValues homeManagerModules)
                ++ [
                  ./home-manager/home.nix
                ];
            }

            # everything to do with hyprland
            ./graphical/plasma

            # > Our main nixos configuration file <
            (import ./nixos/configuration.nix inputs)
            (import ./machines/roguenix/nixos/configuration.nix inputs)
            # (import ./unstable/unstable.nix inputs)
          ];
      };

      elitenix = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules =
          (builtins.attrValues nixosModules)
          ++ [
            kmonad.nixosModules.default

            # home-manager module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.users.marmar.imports =
                (builtins.attrValues homeManagerModules)
                ++ [
                  ./home-manager/home.nix
                ];
            }

            # For sway environment
            ./graphical/sway
            #./graphical/gnome

            (import ./nixos/configuration.nix inputs)
            (import ./machines/elitenix/nixos/configuration.nix inputs)
          ];
      };

      oldnix = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules =
          (builtins.attrValues nixosModules)
          ++ [
            # hyprland.nixosModules.default
            kmonad.nixosModules.default

            # home-manager module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.users.marmar.imports =
                (builtins.attrValues homeManagerModules)
                ++ [
                  ./home-manager/home.nix
                ];
            }

            # > Our main nixos configuration file <
            (import ./nixos/configuration.nix inputs)
            ./machines/oldnix/nixos/configuration.nix
            # (import ./unstable/unstable.nix inputs)

            ./graphical/sway
          ];
      };
    };
  };
}
