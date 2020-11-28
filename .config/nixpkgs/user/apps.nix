{  config, pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    monero-gui
    qbittorrent
    slack
    spotify
    vlc
  ];
}
