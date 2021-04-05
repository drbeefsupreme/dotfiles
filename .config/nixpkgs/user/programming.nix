{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    ccls  #C/C++ language server
    bear  #compilation database maker for C LSP
    nodePackages.node2nix
    nodePackages.typescript
  ];
}
