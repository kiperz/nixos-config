{ config, pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Nix
        jnoortheen.nix-ide

        # Go
        golang.go

        # Rust
        rust-lang.rust-analyzer

        # Git
        eamodio.gitlens

        # Remote
        ms-vscode-remote.remote-ssh

        # General
        editorconfig.editorconfig
        esbenp.prettier-vscode
      ];

      userSettings = {
        # Editor (font family set by Stylix)
        "editor.fontSize" = lib.mkForce 14;
        "editor.fontLigatures" = true;
        "editor.minimap.enabled" = false;
        "editor.renderWhitespace" = "boundary";
        "editor.bracketPairColorization.enabled" = true;
        "editor.smoothScrolling" = true;

        # Terminal (font family set by Stylix)
        "terminal.integrated.fontSize" = lib.mkForce 13;
        "terminal.integrated.defaultProfile.linux" = "fish";

        # Theme (color theme set by Stylix)
        "workbench.iconTheme" = "vs-solarized";

        # Files
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;

        # Nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        # Telemetry off
        "telemetry.telemetryLevel" = "off";

        # Window
        "window.titleBarStyle" = "custom"; # Wayland
      };
    };
  };
}
