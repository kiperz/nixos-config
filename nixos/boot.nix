{ config, pkgs, lib, vars, ... }:

{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true; # Auto-detect Windows on separate drive (nvme1n1)
        configurationLimit = vars.bootGenerations or 10;
        # Stylix handles Solarized Dark colors + wallpaper background
        font = lib.mkForce "${pkgs.terminus_font}/share/fonts/terminus/ter-x24n.pcf.gz";
        fontSize = 24;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    # Informational kernel logs with Solarized-colored TTY
    kernelParams = [
      "loglevel=6"
      "systemd.show_status=true"
      "rd.udev.log_level=3"
    ];

    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # initrd for LUKS + btrfs
    initrd = {
      systemd.enable = true;
      supportedFilesystems = [ "btrfs" ];
    };

    # Btrfs support at runtime
    supportedFilesystems = [ "btrfs" ];

    # Informational console output
    consoleLogLevel = 6;
  };

  # Solarized Dark TTY — beautiful LUKS prompt + kernel logs
  console = {
    earlySetup = true;
    font = "ter-v32n"; # Larger for 4K displays
    packages = [ pkgs.terminus_font ];
    colors = [
      "002b36" # color0  base03 (background)
      "dc322f" # color1  red
      "859900" # color2  green
      "b58900" # color3  yellow
      "268bd2" # color4  blue
      "d33682" # color5  magenta
      "2aa198" # color6  cyan
      "eee8d5" # color7  base2 (foreground)
      "073642" # color8  base02
      "cb4b16" # color9  orange
      "586e75" # color10 base01
      "657b83" # color11 base00
      "839496" # color12 base0
      "6c71c4" # color13 violet
      "93a1a1" # color14 base1
      "fdf6e3" # color15 base3
    ];
  };
}
