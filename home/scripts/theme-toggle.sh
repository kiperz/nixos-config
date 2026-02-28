#!/usr/bin/env bash
# Toggle between Solarized Dark and Light
# This script swaps the Stylix scheme and rebuilds
# For now, it's a placeholder — full Stylix rebuild is slow
# A faster approach: toggle only runtime-switchable components

THEME_FILE="$HOME/.config/nixos/.current-theme"

if [ ! -f "$THEME_FILE" ]; then
  echo "dark" > "$THEME_FILE"
fi

CURRENT=$(cat "$THEME_FILE")

if [ "$CURRENT" = "dark" ]; then
  echo "light" > "$THEME_FILE"
  notify-send "Theme" "Switching to Solarized Light..." --icon=weather-clear
  # For instant effect on GTK apps:
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null
  # Full rebuild for permanent change:
  # nh os switch -- --override-input stylix-scheme solarized-light
else
  echo "dark" > "$THEME_FILE"
  notify-send "Theme" "Switching to Solarized Dark..." --icon=weather-clear-night
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null
fi

# Reload Waybar
pkill waybar && hyprctl dispatch exec waybar &
