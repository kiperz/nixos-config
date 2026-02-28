{ config, pkgs, ... }:

{
  services.flatpak.enable = true;

  # Flathub repo is added automatically by the service,
  # but we ensure it's there:
  # Run after first boot: flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  #
  # Suggested Flatpak apps:
  #   flatpak install flathub md.obsidian.Obsidian
  #   flatpak install flathub dev.vencord.Vesktop
}
