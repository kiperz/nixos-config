{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 3000;
      max-visible = 3;
      anchor = "bottom-left";
      sort = "-time";
      layer = "overlay";
      width = 350;
      height = 120;
      margin = "10";
      padding = "12";
      border-size = 2;
      border-radius = 8;
      font = "SauceCodePro Nerd Font 11";
      # Colors handled by Stylix
    };
  };
}
