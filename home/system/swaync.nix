{ pkgs, ... }:

let
  focus-window = pkgs.writeShellScript "swaync-focus-window" ''
    # Focus the Hyprland window that sent the notification
    window_class="''${SWAYNC_DESKTOP_ENTRY:-$SWAYNC_APP_NAME}"
    [ -n "$window_class" ] && hyprctl dispatch focuswindow "class:(?i)$window_class" 2>/dev/null
  '';
in
{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "left";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "overlay";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-left = 10;
      control-center-margin-right = 10;
      notification-window-width = 360;
      timeout = 3;
      timeout-critical = 0;
      transition-time = 200;
      max-notifications = 3;
      image-visibility = "when-available";
      control-center-width = 500;
      control-center-height = 600;
      scripts = {
        focus-window = {
          exec = "${focus-window}";
          run-on = "action";
        };
      };
    };
  };

  # Enable Stylix theming for swaync
  stylix.targets.swaync.enable = true;
}
