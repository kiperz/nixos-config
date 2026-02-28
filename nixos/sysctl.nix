{ config, pkgs, ... }:

{
  # Increase file watcher limit (default 8192 is too low for dev tools)
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };

  # Faster shutdown — don't wait 90s for hanging services
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
}
