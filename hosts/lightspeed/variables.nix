{
  # User
  username = "kiper";
  fullName = "Kacper";
  email = "CHANGEME@example.com"; # Set your email
  gitUsername = "CHANGEME"; # Set your git username

  # System
  hostname = "lightspeed";
  timezone = "Europe/Warsaw";
  locale = "en_US.UTF-8";
  keyboardLayout = "pl";
  keyboardVariant = "programmer";

  # Paths
  configDir = "~/.config/nixos";
  wallpaperPath = "~/wallpapers/space-solarized.png";
  screenshotDir = "~/Pictures/Screenshots";
  screenRecordDir = "~/Videos/Recordings";

  # Monitors — update after first boot with `hyprctl monitors`
  # Left: 27" 4K 60Hz, Right: 32" 4K 240Hz (primary)
  monitorLeft = "DP-1"; # CHANGEME after first boot
  monitorRight = "DP-2"; # CHANGEME after first boot

  # Theme
  theme = "solarized-dark"; # or "solarized-light"

  # Hyprsunset (Warsaw coordinates for auto schedule)
  latitude = 52.23;
  longitude = 21.01;
}
