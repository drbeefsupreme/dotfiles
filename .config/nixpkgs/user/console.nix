{ config, lib, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
    };
  };
}
