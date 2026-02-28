# NixOS Bonkers Setup — `lightspeed`

> NixOS + Hyprland + Solarized · dual 4K · NVIDIA RTX 3090 Ti · btrfs on LUKS

## Quick Start

### 1. Install NixOS (minimal ISO)

```bash
# Partition (Drive 1: NixOS)
gdisk /dev/nvme0n1
# p1: 512M EFI (ef00), label: BOOT
# p2: remaining, Linux filesystem (8300), label: CRYPTBTRFS

# Encrypt
cryptsetup luksFormat --type luks2 /dev/disk/by-partlabel/CRYPTBTRFS
cryptsetup open /dev/disk/by-partlabel/CRYPTBTRFS cryptbtrfs

# Create btrfs filesystem
mkfs.fat -F32 -n BOOT /dev/nvme0n1p1
mkfs.btrfs -L nixos /dev/mapper/cryptbtrfs

# Create subvolumes
mount /dev/mapper/cryptbtrfs /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@devel
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@swap
umount /mnt

# Mount subvolumes
mount -o subvol=@root,compress=zstd:1,noatime,space_cache=v2,ssd,discard=async /dev/mapper/cryptbtrfs /mnt
mkdir -p /mnt/{boot,home,nix,devel,var/log,.snapshots,swap}

mount /dev/nvme0n1p1 /mnt/boot
mount -o subvol=@home,compress=zstd:1,noatime,space_cache=v2,ssd,discard=async /dev/mapper/cryptbtrfs /mnt/home
mount -o subvol=@nix,noatime,ssd,discard=async,nodatacow /dev/mapper/cryptbtrfs /mnt/nix
mount -o subvol=@devel,compress=zstd:1,noatime,space_cache=v2,ssd,discard=async /dev/mapper/cryptbtrfs /mnt/devel
mount -o subvol=@log,compress=zstd:1,noatime,space_cache=v2,ssd,discard=async /dev/mapper/cryptbtrfs /mnt/var/log
mount -o subvol=@snapshots,compress=zstd:1,noatime,space_cache=v2,ssd,discard=async /dev/mapper/cryptbtrfs /mnt/.snapshots
mount -o subvol=@swap,noatime,ssd,discard=async,nodatacow /dev/mapper/cryptbtrfs /mnt/swap

# Swap file (match your RAM for hibernation)
btrfs filesystem mkswapfile --size 64g /mnt/swap/swapfile
swapon /mnt/swap/swapfile

# Generate hardware config
nixos-generate-config --root /mnt
```

### 2. Clone and Configure

```bash
# Clone this repo
git clone <your-repo-url> /mnt/home/kiper/.config/nixos

# Copy the generated hardware config
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/home/kiper/.config/nixos/hosts/lightspeed/

# Edit variables.nix — set your email, git username
nano /mnt/home/kiper/.config/nixos/hosts/lightspeed/variables.nix
```

### 3. Install

```bash
nixos-install --flake /mnt/home/kiper/.config/nixos#lightspeed
reboot
```

### 4. Post-Install

```bash
# Set password
passwd kiper

# Fix monitor names
hyprctl monitors
# Update monitorLeft / monitorRight in variables.nix

# Fix wallpaper
# Download a space wallpaper to ~/wallpapers/space-solarized.png
# Or: swww img ~/path/to/image.png

# Fix Stylix wallpaper hash
# nix-prefetch-url <wallpaper-url>
# Update sha256 in themes/default.nix

# Add Flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Flatpak apps
flatpak install flathub md.obsidian.Obsidian
flatpak install flathub dev.vencord.Vesktop

# Rebuild
nh os switch
```

## CHANGEME Markers

Search for `CHANGEME` across the config — these are values you must update:

| File | What |
|------|------|
| `hosts/lightspeed/variables.nix` | email, gitUsername, monitorLeft, monitorRight |
| `hosts/lightspeed/hardware-configuration.nix` | Replace with generated version (btrfs subvolumes auto-detected) |
| `themes/default.nix` | Wallpaper sha256 hash |
| `nixos/nix.nix` | Verify Hyprland cachix public key |
| `home/system/waybar.nix` | temperature hwmon path |

## Key Bindings (Cheat Sheet)

| Bind | Action |
|------|--------|
| `Super+Return` | Terminal (Ghostty + Zellij) |
| `Super+D` | App launcher (Fuzzel) |
| `Super+Q` | Close window |
| `Super+Shift+Q` | Force kill (click to select) |
| `Super+E` | Thunar |
| `Super+Shift+E` | Yazi (terminal) |
| `Super+B` | Firefox |
| `Super+V` | Clipboard history |
| `Super+BackSpace` | Power menu |
| `Super+L` | Lock screen |
| `Super+Space` | Toggle float |
| `Super+F` | Fullscreen |
| `Super+Shift+F` | Fake fullscreen (monocle) |
| `Super+R` | Resize mode (arrows, Esc to exit) |
| `Super+Arrows` | Focus window |
| `Super+Ctrl+Arrows` | Swap windows |
| `Super+Shift+1-9` | Move window to workspace |
| `Super+Shift+Arrows` | Move to adjacent workspace |
| `Super+Tab` | Previous workspace |
| `Alt+Tab` | Cycle windows |
| `Super+.` | Emoji picker |
| `Print` | Screenshot (fullscreen → satty) |
| `Super+Shift+S` | Screenshot (region → satty) |
| `Super+Shift+R` | Toggle screen recording |
| `XF86AudioPlay` | Play/Pause media |
| `XF86AudioNext/Prev` | Next/Previous track |

## Structure

```
├── flake.nix                    # Entry point
├── hosts/lightspeed/
│   ├── configuration.nix        # System config
│   ├── hardware-configuration.nix # Generated
│   ├── home.nix                 # Home Manager entry
│   └── variables.nix            # Per-machine values
├── nixos/                       # System modules
│   ├── audio.nix                # PipeWire
│   ├── bluetooth.nix            # Bluez + Blueman
│   ├── boot.nix                 # LUKS + btrfs + systemd-boot
│   ├── btrfs.nix                # btrfs scrub + btrbk snapshots
│   ├── docker.nix               # Docker daemon
│   ├── flatpak.nix              # Flatpak + Flathub
│   ├── gpu.nix                  # NVIDIA 3090 Ti
│   ├── greetd.nix               # GUI login
│   ├── locale.nix               # Warsaw, PL layout
│   ├── networking.nix           # NetworkManager
│   ├── nix.nix                  # Flakes, GC, caches
│   ├── printing.nix             # CUPS + PDF printer
│   ├── sysctl.nix               # inotify limits, fast shutdown
│   └── users.nix                # kiper account
├── home/
│   ├── packages.nix             # All user packages
│   ├── programs/                # App configs
│   │   ├── browser.nix          # Firefox + extensions
│   │   ├── editor.nix           # VSCode
│   │   ├── fish.nix             # Fish + Starship
│   │   ├── ghostty.nix          # Terminal
│   │   ├── git.nix              # Git + delta
│   │   ├── neovim.nix           # NixVim full IDE
│   │   ├── yazi.nix             # TUI file manager
│   │   └── zellij.nix           # Multiplexer
│   ├── system/                  # Desktop environment
│   │   ├── hyprland.nix         # WM + keybinds + rules
│   │   ├── waybar.nix           # Status bar
│   │   ├── fuzzel.nix           # Launcher
│   │   ├── mako.nix             # Notifications
│   │   ├── hypridle.nix         # Idle management
│   │   ├── hyprlock.nix         # Lock screen
│   │   └── swww.nix             # Wallpaper
│   └── scripts/                 # Helper scripts
│       ├── power-menu.sh
│       ├── theme-toggle.sh
│       └── screen-record.sh
└── themes/
    └── default.nix              # Stylix Solarized config
```

## Future Additions

- [ ] VFIO GPU passthrough module (when secondary GPU acquired)
- [ ] sops-nix encrypted secrets
- [ ] Gaming runtime (Steam + Proton, gamemode, mangohud)
- [ ] GPG signing for git commits