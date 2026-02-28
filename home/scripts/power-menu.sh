#!/usr/bin/env bash
# Power menu via fuzzel dmenu

OPTIONS="🔒 Lock\n🚪 Logout\n🔄 Reboot\n⏻ Shutdown\n💤 Hibernate"

CHOICE=$(echo -e "$OPTIONS" | fuzzel --dmenu --prompt="Power ❯ " --width=20 --lines=5)

case "$CHOICE" in
  "🔒 Lock")
    hyprlock
    ;;
  "🚪 Logout")
    hyprctl dispatch exit
    ;;
  "🔄 Reboot")
    systemctl reboot
    ;;
  "⏻ Shutdown")
    systemctl poweroff
    ;;
  "💤 Hibernate")
    systemctl hibernate
    ;;
esac
