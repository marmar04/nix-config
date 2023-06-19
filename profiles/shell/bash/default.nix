{config, pkgs, lib, inputs, ...}:{
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager.sharedModules = [
    {
      bash = {
        enable = true;
        initExtra = builtins.readFile ./bashrc;
      };
    }
  ];

  programs = {
    bash.enable = true;
  };
}
