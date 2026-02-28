# WARNING: This is a PLACEHOLDER. Replace with the output of:
#   sudo nixos-generate-config --show-hardware-config
# Run this during NixOS installation.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # --- PLACEHOLDER VALUES — REPLACE AFTER nixos-generate-config ---

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # NVMe Drive 1: NixOS (LVM on LUKS)
  # EFI partition
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # Root (inside LUKS → LVM)
  fileSystems."/" = {
    device = "/dev/vg-nixos/lv-root";
    fsType = "ext4";
  };

  # Home (inside LUKS → LVM)
  fileSystems."/home" = {
    device = "/dev/vg-nixos/lv-home";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/vg-nixos/lv-swap"; }
  ];

  # LUKS
  boot.initrd.luks.devices."cryptlvm" = {
    device = "/dev/disk/by-partlabel/CRYPTLVM"; # CHANGEME: use actual partition UUID
    preLVM = true;
    allowDiscards = true; # SSD TRIM through LUKS
  };

  # CPU
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
