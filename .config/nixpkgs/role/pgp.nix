#~/.config/nixpkgs/user/pgp.nix

{  config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kleopatra
  ];
}
