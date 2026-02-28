{ config, pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = false;
        grace = 3;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
        noise = 0.02;
        contrast = 0.9;
        brightness = 0.7;
        vibrancy = 0.17;
      }];

      label = [
        # Clock
        {
          text = "cmd[update:1000] echo $(date +%H:%M)";
          font_size = 96;
          font_family = "SauceCodePro Nerd Font";
          position = "0, 150";
          halign = "center";
          valign = "center";
          # Solarized base1
          color = "rgb(93a1a1)";
        }
        # Date
        {
          text = "cmd[update:60000] echo $(date '+%A, %B %d')";
          font_size = 20;
          font_family = "Noto Sans";
          position = "0, 70";
          halign = "center";
          valign = "center";
          color = "rgb(839496)";
        }
        # Username
        {
          text = "Hi, $USER";
          font_size = 14;
          font_family = "Noto Sans";
          position = "0, -30";
          halign = "center";
          valign = "center";
          color = "rgb(586e75)";
        }
      ];

      input-field = [{
        size = "300, 50";
        outline_thickness = 2;
        dots_size = 0.25;
        dots_spacing = 0.3;
        dots_center = true;
        fade_on_empty = true;
        fade_timeout = 2000;
        placeholder_text = "<i>Password...</i>";
        hide_input = false;
        position = "0, -100";
        halign = "center";
        valign = "center";
        # Solarized colors
        outer_color = "rgb(073642)";
        inner_color = "rgb(002b36)";
        font_color = "rgb(93a1a1)";
        check_color = "rgb(b58900)";
        fail_color = "rgb(dc322f)";
        capslock_color = "rgb(cb4b16)";
      }];
    };
  };
}
