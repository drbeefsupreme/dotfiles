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

  # programs.bash = {
  #   enable = true;

  #   #extra commands run when initializing an int. shell
  #   initExtra = ''
  #     #actually run fish instead of bash
  #     exec fish
  #   '';
  # };
}
