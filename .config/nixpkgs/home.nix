{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.


  home.stateVersion = "20.03";
  #home.username = "poprox";
  #home.sessionVariables = {
  #  NIX_PATH = "/home/poprox/.nix-defexpr/channels:nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixpkgs:/nix/var/nix/profiles/per-user/root/channels";
  #};


  nixpkgs.config.allowUnfree = true;

  imports = [
    #configs
    #./machine/syzygyzer.nix
    #./role/xsettings.nix
    ./role/pgp.nix
    ./wm/display.nix
    ./wm/xsession.nix
    ./user/browsers.nix
    ./user/utilities.nix
    ./user/git.nix
    ./user/console.nix
    ./user/apps.nix
    ./user/emacs.nix
    ./user/trezor.nix
    ./user/arduino.nix
    ./user/programming.nix
 ];

  nixpkgs.overlays = [ (import ./overlays/emacsGcc.nix) ]; #(import ./overlays/discord.nix) ]; # (import ./overlays/discord.nix) ];
}
