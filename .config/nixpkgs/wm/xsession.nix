{ config, lib, pkgs, ... }:

{

  #xmonad stuff

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
  };

  # xsession = {
  #   enable = true;

  #   windowManager = {
  #     default = "none+xmonad";
  #     xmonad = {
  #       enable = true;
  #       enableContribAndExtras = true;
  #       extraPackages = hp: [
  #         hp.dbus
  #         hp.monad-logger
  #         hp.monad-contrib
  #       ];
  #     };
  #   };
  # };
}
