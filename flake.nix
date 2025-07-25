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

    # lix package manager
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvix = {
      url = "github:niksingh710/nvix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";

    # grub theming
    darkmatter-grub-theme = {
      url = "github:marmar04/darkmatter-grub2-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #hyprland = {
    #  url = "github:hyprwm/Hyprland";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # window manager
    #niri.url = "github:sodiboo/niri-flake";

    # an anime game launcher
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # keyboard remapping
    #kmonad = {
    #  url = "github:kmonad/kmonad?dir=nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # Nix User Repository
    nur = {
      url = "github:nix-community/NUR";
    };

    # For command-not-found
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    #nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    neovim-flake,
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

            ./graphical/plasma

            # > Our main nixos configuration file <
            (import ./profiles/common/graphical inputs)
            #(import ./machines/roguenix/nixos/configuration.nix inputs)
            ./machines/roguenix/nixos/configuration.nix
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
            ./graphical/plasma
            #./graphical/gnome

            (import ./profiles/common/graphical inputs)
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
            (import ./profiles/common/graphical inputs)
            ./machines/oldnix/nixos/configuration.nix
            # (import ./unstable/unstable.nix inputs)

            ./graphical/sway
          ];
      };
    };
  };
}
