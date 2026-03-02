{ config, pkgs, lib, ... }:

let
  # Hides tabs toolbar and URL bar — SSB/PWA feel
  # Ctrl+L still opens the URL bar; F6 cycles focus
  minimalChrome = ''
    #TabsToolbar { visibility: collapse !important; }
    #nav-bar { visibility: collapse !important; }
  '';

  mkPwa = { id, name, url, class, icon }: {
    profile = {
      inherit id;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.inTitlebar" = 0;
        "widget.use-xdg-desktop-portal.notifications" = 1;
      };
      userChrome = minimalChrome;
    };
    desktopEntry = {
      inherit name icon;
      exec = "firefox -P \"${class}\" --class \"${class}\" --no-remote \"${url}\"";
      terminal = false;
      categories = [ "Network" ];
      startupNotify = true;
      settings.StartupWMClass = class;
    };
  };

  pwas = {
    messenger = mkPwa { id = 1; name = "Messenger"; url = "https://messenger.com";    class = "messenger"; icon = "firefox"; };
    gmail     = mkPwa { id = 2; name = "Gmail";     url = "https://mail.google.com"; class = "gmail";     icon = "gmail";     };
    claude    = mkPwa { id = 3; name = "Claude";    url = "https://claude.ai";       class = "claude";    icon = "firefox"; };
    github    = mkPwa { id = 4; name = "GitHub";    url = "https://github.com";      class = "github";    icon = "github";    };
  };
in
{
  programs.firefox.profiles =
    lib.mapAttrs (_: p: p.profile) pwas;

  xdg.desktopEntries =
    lib.mapAttrs (_: p: p.desktopEntry) pwas;

  # Activation script to fetch PWA manifest icons (best-effort, non-blocking)
  home.activation.fetchPwaIcons = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.local/share/icons/hicolor/192x192/apps"

    # Helper function to fetch icon from PWA manifest
    fetchPwaIcon() {
      local name="$1"
      local url="$2"
      local iconDir="$HOME/.local/share/icons/hicolor/192x192/apps"

      # Try to fetch manifest.json (with timeout, silent fail)
      local manifest
      manifest=$(timeout 5 ${pkgs.curl}/bin/curl -s "$url/manifest.json" 2>/dev/null) || return 0

      [ -z "$manifest" ] && manifest=$(timeout 5 ${pkgs.curl}/bin/curl -s "$url/site.webmanifest" 2>/dev/null) || return 0

      # Extract icon URL - prefer 192x192 or largest
      local iconUrl
      iconUrl=$(echo "$manifest" | ${pkgs.jq}/bin/jq -r '.icons[] | select(.sizes | contains("192")) | .src' 2>/dev/null | head -1)
      [ -z "$iconUrl" ] && iconUrl=$(echo "$manifest" | ${pkgs.jq}/bin/jq -r '.icons[].src' 2>/dev/null | head -1)

      [ -z "$iconUrl" ] && return 0

      # Make absolute URL if relative
      if [[ ! "$iconUrl" =~ ^https?:// ]]; then
        iconUrl="$url/''${iconUrl#/}"
      fi

      # Download icon
      timeout 10 ${pkgs.curl}/bin/curl -sLf "$iconUrl" -o "$iconDir/$name.png" 2>/dev/null || return 0
    }

    # Fetch icons (best-effort, don't block on errors)
    fetchPwaIcon "gmail" "https://mail.google.com" || true
    fetchPwaIcon "github" "https://github.com" || true

    # Update icon cache
    ${pkgs.gtk3}/bin/gtk-update-icon-cache -q "$HOME/.local/share/icons/hicolor" 2>/dev/null || true
  '';
}
