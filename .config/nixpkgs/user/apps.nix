{  config, pkgs, ... }:
let
   unstable = import  <nixos-unstable> {};
in
{
  home.packages = with pkgs; [
    calibre   
    unstable.discord   #done with overlay
    ledger-live-desktop
    monero-gui
    qbittorrent
    signal-desktop
    slack
    spotify
    #steam
    tdesktop #telegram
    vlc
  ];
}
