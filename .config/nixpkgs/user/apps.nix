{  config, pkgs, ... }:

{
  home.packages = with pkgs; [
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
