{ config, pkgs, ... }:

{
  programs.git = {
    enable=true;
    userName="syzygyzer";
    userEmail="jon@tlon.io";
  };

#additional git packages. note that gitFull includes git and so won't work cuz its covered by the above
  home.packages = with pkgs; [
    git-lfs  #large binaries
    gitAndTools.gh   #gh cli
    gitAndTools.git-extras  #repl, stats..
    gitAndTools.git-annex
  ];
}
