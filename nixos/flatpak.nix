{ config, pkgs, ... }:

{
  services.flatpak = {
    enable = true;

    # Declarative Flathub remote (via nix-flatpak)
    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];
  };
}
