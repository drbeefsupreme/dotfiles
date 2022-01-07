{  config, pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    google-chrome
    firefox
    #tor-browser-bundle-bin
  ];

  programs.chromium = {
    enable = true;
    # browsers.brave.enable = true;
  };
  # programs.brave.enable = true;

}
