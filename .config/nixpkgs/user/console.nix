{ config, lib, pkgs, ... }:

{
  # programs.kitty = {
  #   enable = true;
  # };
  # does not seem to work atm, installed via apt
  # https://github.com/NixOS/nixpkgs/issues/80936

  # programs.alacritty = {
  #   enable = true;
  # };

  programs.fish = {             #
    enable = true;

    shellAliases = {
      config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
    };
  };

  programs.bash = {
    enable = true;

    #extra commands run when initializing a login shell
    #profileExtra = ''
    #export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
    #'';
  };


  #console apps
  home.packages = with pkgs; [
    ranger
  ];
}
