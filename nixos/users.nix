{ config, pkgs, ... }:

let
  vars = import ../hosts/lightspeed/variables.nix;
in
{
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.fullName;
    extraGroups = [
      "wheel" # sudo
      "networkmanager"
      "docker"
      "video"
      "audio"
      "input"
      "render"
    ];
    shell = pkgs.fish;
  };

  # Enable Fish system-wide (needed for user shell)
  programs.fish.enable = true;
}
