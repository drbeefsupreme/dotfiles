{  config, pkgs, ... }:

{
  home.packages = with pkgs; [
    discord   #done with overlay
    monero-gui
    qbittorrent
    slack
    spotify
    #steam
    vlc
  ];
}
