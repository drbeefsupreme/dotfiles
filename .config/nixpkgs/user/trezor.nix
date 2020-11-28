{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python38Packages.trezor
    python38Packages.trezor_agent
  ];
}
