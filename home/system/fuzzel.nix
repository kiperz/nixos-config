{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "SauceCodePro Nerd Font:size=13";
        terminal = "ghostty -e";
        prompt = "❯ ";
        layer = "overlay";
        width = 40;
        lines = 12;
        horizontal-pad = 16;
        vertical-pad = 12;
        inner-pad = 8;
      };
      border = {
        width = 2;
        radius = 8;
      };
      dmenu = {
        exit-immediately-if-empty = true;
      };
      # Colors handled by Stylix
    };
  };
}
