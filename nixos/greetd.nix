{ config, pkgs, ... }:

{
  services.greetd.enable = true;

  # regreet config
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = config.stylix.image;
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };

  # Ensure Hyprland is available as a session
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
