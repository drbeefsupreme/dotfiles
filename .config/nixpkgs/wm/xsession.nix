{ config, lib, pkgs, ... }:

{

  #xmonad stuff

  programs.rofi = {
    enable = true;
    #terminal = "${pkgs.kitty}/bin/kitty";
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

  home.packages = with pkgs; [
      nitrogen  #wallpaper - doesn't make symlink?
      #xmobar
  ];


  # services = {
  #     picom = {
  #       enable = true;
  #       fade = true;
  #       vSync = true;
  #       experimentalBackends = true;
  #       the default 'glx' backend lags like crazy for me for some reason.
  #       backend = "xrender";
  #       fadeDelta = 1;
  #       I only want transparency for a couple of applications.
  #       opacityRule = [
  #         "95:class_g *?= 'emacs' && focused"
  #         "75:class_g *?= 'emacs' && !focused"
  #         "90:class_g ?= 'alacritty' && focused"
  #         "75:class_g ?= 'alacritty' && !focused"
  #       ];
  #     };
  # };
}
