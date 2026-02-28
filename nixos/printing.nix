{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
    ];
  };

  # Network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    system-config-printer
  ];
}
