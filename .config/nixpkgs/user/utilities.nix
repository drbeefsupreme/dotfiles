#~/.config/nixpkgs/user/poprox-utilities.nix

{  config, pkgs, ... }:

{
  home.packages = with pkgs; [
    #networking
    arp-scan
    google-cloud-sdk

    #compatibility
    appimage-run

    #overview
    htop
    pciutils

    #system
    killall

    #shelly things
    xclip

    #graphics
    graphviz   #programming language for graphs

    #jokes
    fortune

    unrar
    unzip
  ];
}
