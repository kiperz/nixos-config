{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;

    settings = [{
      layer = "top";
      position = "bottom";
      height = 36;
      spacing = 4;

      # Layout: launcher | temps/mounts | workspaces | ··· | tray | system | clock
      modules-left = [
        "custom/launcher"
        "cpu"
        "memory"
        "temperature"
        "disk"
        "hyprland/workspaces"
      ];

      modules-center = [ ];

      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "bluetooth"
        "custom/weather"
        "custom/theme-toggle"
        "clock"
      ];

      # ── Module configs ──────────────────────────────────

      "custom/launcher" = {
        format = " ";
        on-click = "fuzzel";
        tooltip = false;
      };

      cpu = {
        format = " {usage}%";
        interval = 5;
        tooltip = true;
      };

      memory = {
        format = " {percentage}%";
        interval = 5;
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
      };

      temperature = {
        hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon"; # CHANGEME: AMD CPU temp
        input-filename = "temp1_input";
        critical-threshold = 80;
        format = " {temperatureC}°C";
        format-critical = " {temperatureC}°C";
        interval = 5;
      };

      disk = {
        format = "󰋊 {percentage_used}%";
        path = "/";
        interval = 30;
        tooltip-format = "{path}: {used} / {total}";
      };

      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
        sort-by-number = true;
        all-outputs = true;
      };

      tray = {
        spacing = 8;
        icon-size = 16;
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 muted";
        format-icons = {
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        on-click = "pavucontrol";
        on-click-right = "swayosd-client --output-volume mute-toggle";
      };

      network = {
        format-wifi = "󰖩 {signalStrength}%";
        format-ethernet = "󰈁 {ipaddr}";
        format-disconnected = "󰖪 off";
        tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
        tooltip-format-ethernet = "{ifname}\n{ipaddr}/{cidr}";
        on-click = "nm-connection-editor";
      };

      bluetooth = {
        format = "󰂯";
        format-connected = "󰂱 {device_alias}";
        format-disabled = "󰂲";
        on-click = "blueman-manager";
        tooltip-format-connected = "{device_enumerate}";
      };

      "custom/weather" = {
        format = "{}";
        exec = "curl -s 'wttr.in/Warsaw?format=%c+%t' 2>/dev/null || echo '?'";
        interval = 900; # 15 minutes
        tooltip = false;
      };

      "custom/theme-toggle" = {
        format = "󰖨"; # Sun/moon icon
        on-click = "$HOME/.config/nixos/home/scripts/theme-toggle.sh";
        tooltip-format = "Toggle Solarized Dark/Light";
      };

      clock = {
        format = "  {:%H:%M}";
        format-alt = "  {:%A, %B %d, %Y}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='#93a1a1'><b>{}</b></span>";
            days = "<span color='#839496'>{}</span>";
            weeks = "<span color='#586e75'>W{}</span>";
            weekdays = "<span color='#b58900'><b>{}</b></span>";
            today = "<span color='#cb4b16'><b><u>{}</u></b></span>";
          };
        };
      };
    }];

    # Solarized CSS — Stylix provides base colors, this adds layout styling
    style = ''
      * {
        font-family: "SauceCodePro Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        /* Stylix handles background color via base16 */
        border: none;
      }

      #custom-launcher {
        padding: 0 12px;
        font-size: 18px;
      }

      #cpu, #memory, #temperature, #disk {
        padding: 0 8px;
      }

      #temperature.critical {
        color: #dc322f;
      }

      #workspaces button {
        padding: 0 6px;
        border-radius: 4px;
        margin: 2px;
      }

      #workspaces button.active {
        font-weight: bold;
      }

      #tray {
        padding: 0 8px;
      }

      #pulseaudio, #network, #bluetooth {
        padding: 0 8px;
      }

      #pulseaudio.muted {
        opacity: 0.5;
      }

      #custom-weather {
        padding: 0 8px;
      }

      #custom-theme-toggle {
        padding: 0 8px;
        font-size: 16px;
      }

      #clock {
        padding: 0 12px;
        font-weight: bold;
      }
    '';
  };
}
