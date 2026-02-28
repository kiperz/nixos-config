{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI essentials
    ripgrep
    fd
    eza
    jq
    httpie
    curlie
    unzip
    zip
    file
    tree
    tldr
    du-dust

    # Dev tools
    lazygit
    lazydocker

    # Hyprland ecosystem
    hyprpicker # Color picker
    hyprsunset # Night light
    swayosd # Volume OSD

    # Screenshot / recording
    grim
    slurp
    satty
    gpu-screen-recorder

    # Clipboard
    wl-clipboard
    cliphist

    # Wallpaper
    swww

    # Emoji picker
    bemoji

    # Media
    mpv
    imv

    # File management
    xfce.thunar
    xfce.thunar-volman
    udiskie

    # Notifications
    libnotify # notify-send

    # Auth / security
    keepassxc
    polkit_gnome

    # Appearance
    papirus-icon-theme
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum

    # Networking
    networkmanagerapplet

    # System info
    fastfetch

    # Wayland utilities
    wtype # Keyboard input simulation (for emoji picker)

    # Nix tools
    nix-output-monitor

    # lorri for direnv
    lorri
  ];
}
