#~/.config/nixpkgs/user/poprox-utilities.nix

{  config, pkgs, ... }:

{
  home.packages = with pkgs; [
    #networking
    arp-scan
    google-cloud-sdk

    #overview
    htop

    #security
    #_1password

    #shelly things
    xclip

    #graphics
    graphviz   #programming language for graphs

    #jokes
    fortune

    unrar
  ];
}
