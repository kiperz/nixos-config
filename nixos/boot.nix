{ config, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false; # Security: prevent kernel param editing
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    # Clean boot: suppress kernel spam, keep systemd status visible
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];

    # Plymouth disabled intentionally — we want to see systemd startup
    # but without the kernel debug wall

    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # initrd for LUKS + LVM
    initrd = {
      systemd.enable = true;
      kernelModules = [ "dm-snapshot" ];
    };

    # Console font (larger for 4K)
    consoleLogLevel = 3;
  };

  # Early console font for HiDPI
  console = {
    earlySetup = true;
    font = "ter-v24n";
    packages = [ pkgs.terminus_font ];
  };
}
