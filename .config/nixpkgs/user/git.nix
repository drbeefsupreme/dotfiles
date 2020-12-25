{ config, pkgs, ... }:

{
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable=true;
    userName="drbeefsupreme";
    userEmail="drbeefsupreme@discordja.net";
    signing = {
      key = "B70D5683DE7F9EFC";
      signByDefault = true;
    };
    lfs.enable = true;

  };
}
