{ config, pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # Dim screen at 5 minutes
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        # Lock at 10 minutes
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        # DPMS off at 15 minutes (screens off, no suspend)
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
