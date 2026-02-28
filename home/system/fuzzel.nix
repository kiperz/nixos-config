{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        # Font set by Stylix
        terminal = "ghostty -e";
        prompt = "❯ ";
        placeholder = "Search...";
        layer = "overlay";
        width = 45;
        lines = 10;
        horizontal-pad = 24;
        vertical-pad = 16;
        inner-pad = 12;
        icon-theme = "Papirus";
        image-size-ratio = 0.7;
        match-counter = true;
        line-height = 26;
        letter-spacing = 1;
        use-bold = true;
      };
      border = {
        width = 3;
        radius = 12;
      };
      dmenu = {
        exit-immediately-if-empty = true;
      };
      # Colors handled by Stylix
    };
  };
}
