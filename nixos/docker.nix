{ config, pkgs, ... }:

let
  vars = import ../hosts/lightspeed/variables.nix;
in
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Add user to docker group (also done in users.nix, but explicit here)
  users.users.${vars.username}.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker
  ];
}
