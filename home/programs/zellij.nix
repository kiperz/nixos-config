{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;

    settings = {
      theme = "default"; # Stylix handles colors
      default_layout = "default";
      pane_frames = true;
      simplified_ui = false; # Show keybind hints

      ui = {
        pane_frames = {
          rounded_corners = true;
        };
      };

      # Don't auto-start from shell — Fish handles the attach
      # This prevents nested zellij sessions
    };
  };
}
