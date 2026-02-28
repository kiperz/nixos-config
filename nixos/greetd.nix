{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  # regreet config
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/etc/greetd/wallpaper.png"; # Symlink your wallpaper here
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
