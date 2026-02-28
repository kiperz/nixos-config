{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Emacs-style keybinds (default, explicit)
      fish_default_key_bindings

      # No greeting
      set -g fish_greeting

      # Zellij auto-attach (if not already inside zellij)
      if not set -q ZELLIJ
        zellij attach --create default
      end
    '';

    shellAbbrs = {
      # Nix
      nrs = "nh os switch";
      nrt = "nh os test";
      nrb = "nh os boot";
      nfu = "nix flake update";
      nse = "nix search nixpkgs";
      nsh = "nix-shell -p";
      ndev = "nix develop";

      # Git
      g = "git";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      gs = "git status";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      lg = "lazygit";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Modern replacements
      ls = "eza --icons";
      ll = "eza -la --icons --git";
      lt = "eza --tree --icons --level=2";
      cat = "bat";
      find = "fd";
      grep = "rg";
      top = "btm";
      du = "dust";

      # Docker
      dc = "docker compose";
      dcu = "docker compose up -d";
      dcd = "docker compose down";
      dcl = "docker compose logs -f";
      ld = "lazydocker";

      # System
      ff = "fastfetch";
      cls = "clear";
    };

    functions = {
      # Quick directory creation and cd
      mkcd = "mkdir -p $argv[1] && cd $argv[1]";

      # Extract anything
      extract = ''
        switch $argv[1]
          case '*.tar.bz2'; tar xjf $argv[1]
          case '*.tar.gz'; tar xzf $argv[1]
          case '*.tar.xz'; tar xJf $argv[1]
          case '*.bz2'; bunzip2 $argv[1]
          case '*.gz'; gunzip $argv[1]
          case '*.tar'; tar xf $argv[1]
          case '*.tbz2'; tar xjf $argv[1]
          case '*.tgz'; tar xzf $argv[1]
          case '*.zip'; unzip $argv[1]
          case '*.7z'; 7z x $argv[1]
          case '*'; echo "Cannot extract '$argv[1]'"
        end
      '';
    };
  };

  # Starship prompt — compact one-line
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$nix_shell$character";

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      git_branch = {
        format = "[$branch]($style) ";
        style = "bold green";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold yellow";
      };

      nix_shell = {
        format = "[$symbol$name]($style) ";
        symbol = " ";
        style = "bold blue";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      # Disable modules we don't need on the prompt line
      cmd_duration.disabled = true;
      hostname.disabled = true;
      username.disabled = true;
    };
  };
}
