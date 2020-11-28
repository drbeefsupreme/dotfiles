{ config, lib, pkgs, ... }:

{
  xsession = {
    enable = true;

    windowManager = {
      xmonad = {
        enable = true;
      };
    };
  };
}
