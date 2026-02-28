{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Battery level reporting
      };
    };
  };

  services.blueman.enable = true;
}
