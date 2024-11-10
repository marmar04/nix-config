# Module for optimus laptops
{
  config,
  pkgs,
  lib,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  # Install the latest nvidia driver
  services.xserver.videoDrivers = ["nvidia"];

  # Install shell script declared on top
  environment.systemPackages = [nvidia-offload];

  # To get projectors to work by using specialisation
  #specialisation = {
  #  external-display.configuration = {
  #    system.nixos.tags = ["external-display"];
  #    hardware.nvidia = {
  #      prime = {
  #        offload.enable = lib.mkForce false;
  #        offload.enableOffloadCmd = lib.mkForce false;
  #      };
  #      # Disable power management of the card
  #      powerManagement = {
  #        enable = lib.mkForce false;
  #        finegrained = lib.mkForce false;
  #      };
  #    };
  #  };
  #};

  hardware = {
    graphics.enable = true;

    nvidia = {
      modesetting.enable = true;

      open = true;

      prime = {
        # Make prime offloading work
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        #sync.enable = true;

        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:0:2:0";
        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:1:0:0";
      };

      powerManagement = {
        enable = true;
        finegrained = true;
      };

      #nvidiaSettings = true;
    };
  };
}
