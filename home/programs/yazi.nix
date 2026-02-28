{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
        show_symlink = true;
      };
      opener = {
        edit = [
          { run = ''nvim "$@"''; block = true; }
        ];
        open = [
          { run = ''xdg-open "$@"''; orphan = true; }
        ];
        reveal = [
          { run = ''thunar "$(dirname "$1")"''; orphan = true; }
        ];
      };
    };
  };
}
