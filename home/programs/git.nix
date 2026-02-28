{ config, pkgs, ... }:

let
  vars = import ../../hosts/lightspeed/variables.nix;
in
{
  programs.git = {
    enable = true;
    userName = vars.gitUsername;
    userEmail = vars.email;

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      diff.algorithm = "histogram";
      merge.conflictstyle = "zdiff3";
      rerere.enabled = true;
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        syntax-theme = "base16";
      };
    };
  };
}
