# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {

  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # It's strongly recommended you take a look at
    # https://github.com/nixos/nixos-hardware
    # and import modules relevant to your hardware.

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # You can also split up your configuration and import pieces of it here.
  ];

  # Set your hostname
  networking.hostName = "elitenix";

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;

    kernelParams = [ "quiet" ];
    
    # Mount NTFS drives with ntfs-3g
    supportedFilesystems = [ "ntfs" "btrfs" "exfat" ];
    
    # Swappiness of the machine
    kernel.sysctl = { "vm.swappiness" = 45; };

    resumeDevice = "/dev/sda2";
  };

  # FIXME: Add a boot loader

  # Bootloader

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd = {
    services.NetworkManager-wait-online.enable = false;
    tmpfiles = {
      rules = [
        "L+ /lib/${builtins.baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker} - - - - ${pkgs.stdenv.cc.bintools.dynamicLinker}"
        "L+ /lib64 - - - - /lib"
      ];
    };
  };

  powerManagement = {
    enable = true;
    # cpuFreqGovernor = "schedutil";
    # For maximum power saving, may not be the most convenient
    # powertop.enable = true;
  };

  users.users = {
    # Replace with your username
    marmar = {
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIJtCCRbvvg9o+xW0cHAIzp/euVpY1VZl1QgMvDaloP m.ameerrafiqi@gmail.com"
      ];
      extraGroups = [ "video" "input" "wheel" "networkmanager" "audio" "scanner" "lp" ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
