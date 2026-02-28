{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

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

      # Theme (Stylix handles most, but fallback)
      # Solarized built into VSCode

      # General
      editorconfig.editorconfig
      esbenp.prettier-vscode
    ];

    userSettings = {
      # Editor
      "editor.fontFamily" = "'SauceCodePro Nerd Font', 'monospace', monospace";
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "boundary";
      "editor.bracketPairColorization.enabled" = true;
      "editor.smoothScrolling" = true;

      # Terminal
      "terminal.integrated.fontFamily" = "SauceCodePro Nerd Font";
      "terminal.integrated.fontSize" = 13;
      "terminal.integrated.defaultProfile.linux" = "fish";

      # Theme
      "workbench.colorTheme" = "Solarized Dark";
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
}
