{ pkgs, ... }:
{
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    # For virt-manager
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
    spiceUSBRedirection.enable = true;

    #waydroid.enable = true;

    # enable vmware because qemu has network problems
    vmware.host.enable = true;

    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs.virt-manager.enable = true;

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive            # look into docker image layers
    podman-tui      # status of containers in the terminal
    #docker-compose # start group of containers for dev
    podman-compose  # start group of containers for dev
    #virtiofsd       # Filesystem expose for virtual machines
    dnsmasq
  ];

  # allow network bridge through firewall
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  users.groups.libvirtd.members = ["marmar"];
}
