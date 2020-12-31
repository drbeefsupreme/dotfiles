{ config, lib, pkgs, ... }:

{

  #xmonad stuff

  programs.rofi = {
    enable = true;
    #terminal = "${pkgs.kitty}/bin/kitty";
  };

  # xsession = {
  #   enable = true;

  #   windowManager = {
  #     #default = "none+xmonad";
  #     xmonad = {
  #       enable = true;
  #       enableContribAndExtras = true;
  #       extraPackages = hp: [
  #         hp.dbus
  #         hp.monad-logger
  #         hp.xmonad-contrib
  #       ];
  #     };
  #   };
  # };

  home.packages = with pkgs; [
      nitrogen  #wallpaper - doesn't make symlink?
      # haskellPackages.xmonad-contrib
      # haskellPackages.xmonad-extras
      # haskellPackages.xmonad-wallpaper
      # haskellPackages.xmonad
      # haskellPackages.ghc
      dmenu
      haskellPackages.xmobar
  ];


  #look in .config/picom
  services = {
      picom = {
        enable = true;

        ##shadows
        #shadow = true;
        #shadowOffsets = [ -7 -7 ];

        fade = true;

        ##transparency/opacity
        inactiveOpacity = "1.0";

        opacityRule = [
          "95:class_g *?= 'emacs'"
          "92:class_g *?= 'brave' && name *?='OS1'"
          "95:class_g *?= 'alacritty'"
        ];

        experimentalBackends = true;
        backend = "xrender";
        vSync = true;

        fadeDelta = 1;
        #I only want transparency for a couple of applications.

        # extraOptions = ''
        #   shadow-exclude = [
        #     "name = 'Notification'",
        #     "class_g = 'Conky'",
        #     "class_g ?= 'Notify-osd'",
        #     "class_g = 'Cairo-clock'",
        #     "_GTK_FRAME_EXTENTS@:c"
        #   ];

        #   fade-in-step = 0.03;
        #   fade-out-step = 0.03;

        #   frame-opacity = 0.9;
        #   inactive-opacity-override = false;

        #   focus-exclude = [ "class_g = 'Cairo-clock'" ];

        #   blur-kern = "3x3box";
        #   blur-background-exclude = [
        #   "window_type = 'dock'",
        #   "window_type = 'desktop'",
        #   "_GTK_FRAME_EXTENTS@:c"
        #   ];

        #   mark-wmwin-focused = true;
        #   mark-ovredir-focused = false;
        #   detect-rounded-corners = true;
        #   detect-client-opacity = true;

        #   refresh-rate = 0;

        #   use-emwh-active-win = true;

        #   detect-transient = true;
        #   detect-client-leader = true;

        #   use-damage = true;

        #   log-level = "warn";

        #   wintypes:
        #   {
        #     tooltip = { fade = true; shadow = true; opacity = 0.75; focus = true; full-shadow = false; };
        #     dock = { shadow = false; }
        #     dnd = { shadow = false; }
        #     popup_menu = { opacity = 0.8; }
        #     dropdown_menu = { opacity = 0.8; }
        #   };
        # '';
      };
  };
}
