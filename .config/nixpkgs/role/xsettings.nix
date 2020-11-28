# ~/.config/nixpkgs/role/xsettings.nix
{ config, lib, pkgs, ... }:

{
  xsession.enable = true;
  xsession.windowManager.i3.enable = true;
}
