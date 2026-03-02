{ config, pkgs, lib, ... }:

let
  # Hides tabs toolbar and URL bar — SSB/PWA feel
  # Ctrl+L still opens the URL bar; F6 cycles focus
  minimalChrome = ''
    #TabsToolbar { visibility: collapse !important; }
    #nav-bar { visibility: collapse !important; }
  '';

  # Wrapper script that symlinks session data before launching PWA
  # This allows PWAs to share cookies/extensions with the main browser
  mkPwaLauncher = { class, url }: pkgs.writeShellScript "firefox-${class}" ''
    profilesDir="$HOME/.mozilla/firefox"

    # Find default profile path
    defaultPath=$(find "$profilesDir" -maxdepth 1 -type d -name "*default*" | head -1)
    if [ -z "$defaultPath" ] || [ ! -d "$defaultPath" ]; then
      # Fallback: try to find Profile0 from profiles.ini
      defaultPath="$profilesDir/$(grep '^\[Profile0\]' "$profilesDir/profiles.ini" -A5 | grep '^Path=' | sed 's/^Path=//' | head -1)"
    fi

    # Find PWA profile path
    pwaPath=$(find "$profilesDir" -maxdepth 1 -type d -name "*${class}*" | head -1)

    # Create symlinks for session sharing (cookies, extensions, history)
    if [ -n "$defaultPath" ] && [ -n "$pwaPath" ] && [ -d "$defaultPath" ] && [ -d "$pwaPath" ]; then
      # Symlink cookies for session data
      [ -f "$defaultPath/cookies.sqlite" ] && ln -sf "$defaultPath/cookies.sqlite" "$pwaPath/cookies.sqlite" 2>/dev/null

      # Symlink extensions for same add-ons
      [ -d "$defaultPath/extensions" ] && ln -sf "$defaultPath/extensions" "$pwaPath/extensions" 2>/dev/null
      [ -f "$defaultPath/extensions.json" ] && ln -sf "$defaultPath/extensions.json" "$pwaPath/extensions.json" 2>/dev/null

      # Symlink history
      [ -f "$defaultPath/places.sqlite" ] && ln -sf "$defaultPath/places.sqlite" "$pwaPath/places.sqlite" 2>/dev/null
    fi

    # Launch Firefox PWA
    exec ${pkgs.firefox}/bin/firefox -P "${class}" --class "${class}" --no-remote "${url}"
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
      exec = "${mkPwaLauncher { inherit class url; }}";
      terminal = false;
      categories = [ "Network" ];
      startupNotify = true;
      settings.StartupWMClass = class;
    };
  };

  pwas = {
    messenger = mkPwa { id = 1; name = "Messenger"; url = "https://messenger.com";    class = "messenger"; icon = "firefox"; };
    gmail     = mkPwa { id = 2; name = "Gmail";     url = "https://mail.google.com"; class = "gmail";     icon = "firefox"; };
    claude    = mkPwa { id = 3; name = "Claude";    url = "https://claude.ai";       class = "claude";    icon = "firefox"; };
    github    = mkPwa { id = 4; name = "GitHub";    url = "https://github.com";      class = "github";    icon = "firefox"; };
  };
in
{
  programs.firefox.profiles =
    lib.mapAttrs (_: p: p.profile) pwas;

  xdg.desktopEntries =
    lib.mapAttrs (_: p: p.desktopEntry) pwas;
}
