{ config, pkgs, libs, ... }:

let
  nixos-unstable = import <nixos-unstable> { };
in

{
  home.packages = with pkgs; [
    sqlite  #needed by org-roam
    ripgrep  #needed by doom
    fd  #doom
  ];

  programs.emacs = {
    enable = true;
    package = nixos-unstable.emacsGccWrapped;
  };

}
