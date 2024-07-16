# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{kmonad, ...}: {
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # It's strongly recommended you take a look at
    # https://github.com/nixos/nixos-hardware
    # and import modules relevant to your hardware.
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    inputs.darkmatter-grub-theme.nixosModule

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    #./../../common/optimus.nix
    ./../../../profiles/coding/cpp
    ./../../../profiles/coding/rust
    ./../../../profiles/coding/haskell
    ./../../../profiles/coding/webdev
    ./../../../profiles/coding/database
    ./../../../profiles/math
    ./../../../profiles/games

    # You can also split up your configuration and import pieces of it here.
  ];

  # Set your hostname
  networking.hostName = "roguenix";

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    # extraModulePackages = with config.boot.kernelPackages; [tuxedo-keyboard];

    kernelParams = [
      "ahci.mobile_lpm_policy=3"
      "quiet"
      "nowatchdog"

      "nouveau.config=NvGspRm=1"

      # for keyboard lights
      #"tuxedo_keyboard.mode=0"
      #"tuxedo_keyboard.brightness=255"
      #"tuxedo_keyboard.color_left=0xa6e3a1"
    ];

    # Mount NTFS drives with ntfs-3g
    supportedFilesystems = ["ntfs" "btrfs" "exfat"];

    # Swappiness of the machine
    kernel.sysctl = {
      "vm.swappiness" = 60;

      # For (hopefully) unlimited tethering. Try 129 if this doesn't work
      "net.ipv4.ip_default_ttl" = 65;
      "net.ipv6.conf.all.hop_limit" = 65;
    };
  };

  # Bootloader
  boot.loader = {
    #systemd-boot.enable = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;

      darkmatter-theme = {
        enable = true;
        style = "nixos";
        icon = "color";
        resolution = "1080p";
      };
    };
    efi.canTouchEfiVariables = true;
  };

  # for keyboard monitoring
  hardware = {
    tuxedo-keyboard.enable = true;
    tuxedo-rs = {
      enable = true;
      tailor-gui.enable = true;
    };
  };

  services = {
    xserver = {
      displayManager.gdm.enable = lib.mkDefault false;
      displayManager.lightdm.enable = false;

      # xkbOptions = "compose:ralt";
      # layout = "us";
    };

    fstrim.enable = true;

    # Read the kmonad flake more properly
    /*
    kmonad = {
      enable = false;
      configfiles = [./kmonad.kbd];
    };
    */

    power-profiles-daemon.enable = true;
    # thermald.enable = true;

    tlp = {
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };

    /*
    systemd.tmpfiles.rules = map
      (e:
        "w /sys/bus/${e}/power/control - - - - auto"
      ) [
      "pci/devices/0000:00:01.0" # Renoir PCIe Dummy Host Bridge
      "pci/devices/0000:00:02.0" # Renoir PCIe Dummy Host Bridge
      "pci/devices/0000:00:14.0" # FCH SMBus Controller
      "pci/devices/0000:00:14.3" # FCH LPC bridge
      "pci/devices/0000:04:00.0" # FCH SATA Controller [AHCI mode]
      "pci/devices/0000:04:00.1/ata1" # FCH SATA Controller, port 1
      "pci/devices/0000:04:00.1/ata2" # FCH SATA Controller, port 2
      "usb/devices/1-3" # USB camera
    ];
    */

    # tlp specifically for this device
    /*
    tlp = {
      enable = true;
      # Any other configuration to change just put here
      # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/tlp.nix
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_MIN_PERF_ON_AC = 20;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 17;
        CPU_MAX_PERF_ON_BAT = 50;
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
      };
    };
    */
  };

  programs = {
    zsh.enable = true;
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users = {
    users = {
      # Replace with your username
      marmar = {
        # TODO: You can set an initial password for your user.
        # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
        # Be sure to change it (using passwd) after rebooting!
        # initialPassword = "correcthorsebatterystaple";
        isNormalUser = true;
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtWU/an7RwitlGTKlRWCigWlcFPsdo5g7Wp+wKmEtRn m.ameerrafiqi@gmail.com"
        ];
        # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
        extraGroups = ["video" "uinput" "input" "wheel" "networkmanager" "audio" "scanner" "libvirtd" "lp"];
      };
    };

    # extraUsers = {
    #   nixBuild = {
    #     name = "nixBuild";
    #     useDefaultShell = true;
    #     isSystemUser = true;
    #     group = "nixBuild";
    #     openssh.authorizedKeys.keys = [
    #       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPaSOSh7eH1ekDr76+rmcmbGpvg04nYHTIGo8p7gfqfF nixBuild"
    #     ];
    #   };
    # };
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
