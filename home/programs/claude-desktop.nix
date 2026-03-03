# Claude Desktop — themed Electron app with Stylix base16 colors
# Patches the upstream asar to inject theme CSS via Electron's insertCSS API
#
# Approach: extract asar → rename original main entry → create a new main.js
# that sets up CSS injection then require()s the original. This avoids prepending
# to compiled/minified bundles which can break parsing.
{ config, pkgs, inputs, ... }:

let
  # Stylix base16 palette
  c = config.lib.stylix.colors.withHashtag;

  # Theme CSS — bare rules (no @-moz-document wrapper)
  claudeCSS = import ./pwa-themes/claude.nix { inherit c; };
  themeFile = pkgs.writeText "claude-desktop-theme.css" claudeCSS;

  # JS injection code (reads CSS from store at runtime, hooks every new window)
  # Also pre-launches the cowork VM daemon since the app's internal auto-launch
  # can fail silently on NixOS due to module resolution timing
  injectCode = pkgs.writeText "claude-theme-inject.js" ''
    (function() {
      var electron = require('electron');
      var fs = require('fs');
      var path = require('path');

      // --- Theme CSS injection ---
      var css;
      try {
        css = fs.readFileSync('${themeFile}', 'utf8');
        console.log('[Stylix Theme] Loaded CSS (' + css.length + ' bytes)');
      } catch (e) {
        console.error('[Stylix Theme] Failed to read CSS:', e.message);
      }
      if (css) {
        electron.app.on('browser-window-created', function(_, win) {
          win.webContents.on('dom-ready', function() {
            win.webContents.insertCSS(css).catch(function() {});
          });
        });
      }

      // --- Pre-launch cowork VM daemon ---
      electron.app.on('ready', function() {
        var daemonPath = path.join(
          path.dirname(electron.app.getAppPath()),
          'app.asar.unpacked', 'cowork-vm-service.js'
        );
        if (fs.existsSync(daemonPath)) {
          try {
            var net = require('net');
            var sockPath = (process.env.XDG_RUNTIME_DIR || '/tmp') +
              '/cowork-vm-service.sock';
            var probe = net.createConnection(sockPath);
            probe.on('connect', function() {
              probe.destroy();
              console.log('[VM Launcher] Daemon already running');
            });
            probe.on('error', function() {
              probe.destroy();
              console.log('[VM Launcher] Spawning daemon:', daemonPath);
              var child = require('child_process').fork(daemonPath, [], {
                detached: true,
                stdio: 'ignore',
                env: Object.assign({}, process.env, { ELECTRON_RUN_AS_NODE: '1' })
              });
              child.unref();
              console.log('[VM Launcher] Daemon spawned, pid:', child.pid);
            });
          } catch (e) {
            console.error('[VM Launcher] Error:', e.message);
          }
        } else {
          console.warn('[VM Launcher] Daemon script not found:', daemonPath);
        }
      });
    })();
  '';

  # Original (unthemed) package from the flake
  claude-desktop-orig = inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Patched package: asar with theme injection as new entry point
  claude-desktop-themed = pkgs.stdenvNoCC.mkDerivation {
    pname = "claude-desktop-themed";
    version = claude-desktop-orig.version or "0";
    dontUnpack = true;

    nativeBuildInputs = with pkgs; [ nodePackages.asar nodejs makeWrapper ];

    buildPhase = ''
      runHook preBuild

      # Extract the asar (resolves .unpacked sibling automatically)
      asar extract ${claude-desktop-orig}/lib/claude-desktop/resources/app.asar app

      # Determine main entry point from package.json
      MAIN=$(node -e "console.log(require('./app/package.json').main || 'index.js')")
      MAIN_DIR=$(dirname "$MAIN")
      MAIN_BASE=$(basename "$MAIN")

      echo "Patching asar: main entry is $MAIN"

      # Rename original entry (preserve in same directory for correct require resolution)
      mv "app/$MAIN" "app/$MAIN_DIR/_orig_$MAIN_BASE"

      # Create new entry: inject theme CSS, then load original
      {
        cat ${injectCode}
        echo "require('./_orig_$MAIN_BASE');"
      } > "app/$MAIN"

      # Repack without --unpack; the upstream maintains app.asar.unpacked separately
      asar pack app app.asar

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/claude-desktop/resources $out/bin

      # Patched asar
      cp app.asar $out/lib/claude-desktop/resources/

      # Copy upstream's app.asar.unpacked as-is (contains cowork-vm-service.js,
      # node-pty native modules, claude-native bindings — must stay outside asar)
      cp -r ${claude-desktop-orig}/lib/claude-desktop/resources/app.asar.unpacked \
        $out/lib/claude-desktop/resources/

      # Symlink non-asar resources (tray icons, SSH helpers, locales)
      for item in ${claude-desktop-orig}/lib/claude-desktop/resources/*; do
        name=$(basename "$item")
        [ "$name" = "app.asar" ] || [ "$name" = "app.asar.unpacked" ] && continue
        ln -s "$item" "$out/lib/claude-desktop/resources/$name"
      done

      # Symlink icons & .desktop file
      ln -s ${claude-desktop-orig}/share $out/share

      # Wrapper — same flags as upstream, plus NIX_LD for downloaded binaries
      makeWrapper ${pkgs.electron}/bin/electron $out/bin/claude-desktop \
        --add-flags "$out/lib/claude-desktop/resources/app.asar" \
        --add-flags "--disable-features=CustomTitlebar" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --set-default NIX_LD "${pkgs.stdenv.cc.libc}/lib/ld-linux-x86-64.so.2" \
        --prefix NIX_LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.libc ]}"

      runHook postInstall
    '';

    meta = {
      mainProgram = "claude-desktop";
      description = "Claude Desktop with Stylix theme";
    };
  };
in
{
  home.packages = [ claude-desktop-themed ];
}
