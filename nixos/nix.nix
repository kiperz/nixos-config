{ config, pkgs, ... }:

let
  vars = import ../hosts/lightspeed/variables.nix;
in
{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" vars.username ];
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+ voices2F1vVEr3FOGSo2+ZSTHg0/gOpvFlM=" # CHANGEME: verify at https://app.cachix.org/cache/hyprland
      ];
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };

  # nh (nix helper) for prettier builds
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 5 --keep-since 3d";
    flake = "/home/${vars.username}/.config/nixos";
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor # nom - pretty build output
  ];
}
