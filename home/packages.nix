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
    gh # GitHub CLI
    imagemagick

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
    playerctl # Media key control (play/pause/next/prev)

    # File management
    xfce.thunar
    xfce.thunar-volman
    xfce.tumbler # Thumbnail generation for Thunar
    ffmpegthumbnailer # Video thumbnails
    udiskie

    # Notifications
    libnotify # notify-send

    # Auth / security
    keepassxc
    polkit_gnome

    # Image format support
    webp-pixbuf-loader # WebP in GTK apps

    # Appearance
    papirus-icon-theme
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum

    # System info
    fastfetch

    # Wayland utilities
    wtype # Keyboard input simulation (for emoji picker)

    # Nix tools
    nil # Nix LSP (for VSCode and other editors)

    # Archive support
    p7zip
  ];
}
