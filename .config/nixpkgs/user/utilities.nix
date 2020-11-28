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

    #jokes
    fortune

    unrar
  ];
}
