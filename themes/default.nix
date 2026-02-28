{ config, pkgs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = true;

    # Solarized Dark as base
    base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
    polarity = "dark";

    # Wallpaper (required by Stylix even if swww manages it)
    image = pkgs.fetchurl {
      url = "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=3840&q=95";
      sha256 = "0000000000000000000000000000000000000000000000000000"; # CHANGEME: nix-prefetch-url
      name = "space-solarized-wallpaper.jpg";
    };

    # Fonts
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.sauce-code-pro;
        name = "SauceCodePro Nerd Font";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 13;
      };
    };

    # Cursor
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    # Opacity
    opacity = {
      applications = 1.0;
      desktop = 0.85;
      popups = 0.95;
      terminal = 0.9;
    };

    # Targets — Stylix auto-applies to most, but we can override
    targets = {
      grub.enable = false; # We use systemd-boot
      console.enable = true;
      gtk.enable = true;
    };
  };
}
