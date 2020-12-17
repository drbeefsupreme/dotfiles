{  config, pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    google-chrome
    firefox
    tor-browser-bundle-bin
  ];
}
