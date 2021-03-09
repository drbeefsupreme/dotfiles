{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    ccls  #C/C++ language server
  ];
}
