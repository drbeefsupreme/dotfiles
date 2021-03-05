{  config, pkgs, ... }:

{
  home.packages = with pkgs; [
    calibre   
    discord   #done with overlay
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
