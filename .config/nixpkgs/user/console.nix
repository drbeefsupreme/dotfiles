{ config, lib, pkgs, ... }:

{
  # programs.kitty = {
  #   enable = true;
  # };
  # does not seem to work atm, installed via apt
  # https://github.com/NixOS/nixpkgs/issues/80936

  programs.alacritty = {
    enable = true;
  };

  programs = {
    fish = {
      enable = true;

      interactiveShellInit = ''
        neofetch
      '';

      shellAliases = {
        config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
        neofetch = "ncneofetch";

        ls = "lsd -h";
        l = "ls -lh";
        la = "ls -ah";
        lla = "ls -lah";
        lt = "ls --tree -h";
      };

      # functions = {
      #   fish_prompt = {
      #     body = "eval $GOPATH/bin/powerline-go -error $status -shell bare";
      #   };
      # };

      promptInit = ''
        function fish_prompt
          eval powerline-go -error $status -shell bare
        end
      '';
    };

    bash.enable = true;

    #powerline-go.enable = true;
  };


  #console apps
  home.packages = with pkgs; [
    ffmpegthumbnailer  #video previews
    lsd  #ls deluxe
    mlocate  #find file
    nano
    #powerline-fonts  #fonts with nix seem like a bad idea
    powerline-go  #cool prompt
    ranger   #file explorer
    stig  #front-end for transmission
    tmux
    w3m     #terminal web browser + images for ranger
  ];
}
