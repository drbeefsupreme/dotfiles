# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };

  # nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
  #   export __NV_PRIME_RENDER_OFFLOAD=1
  #   export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  #   export __GLX_VENDOR_LIBRARY_NAME=nvidia
  #   export __VK_LAYER_NV_optimus=NVIDIA_only
  #   exec -a "$0" "$@"
  # '';
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/virtualisation/vfio.nix
      ../modules/virtualisation/libvirt.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Add ZFS support
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;




  ##old virtualization settings
  #############################################################################################
  # #boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];                                  #
  # # turns on KVM                                                                            #
  # #boot.kernelModules = [ "kvm-intel" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ]; #
  # # boot.extraModprobeConfig = "options vfio-pci ids=10de:1f36,10de:10f9";                  #
  # #                                                                                         #
  # #                                                                                         #
  # #                                                                                         #
  # # virtualisation.libvirtd = {                                                             #
  # #   enable = true;                                                                        #
  # #   qemuOvmf = true;  #firmware for UEFI virtual machines                                 #
  # #   qemuRunAsRoot = false;                                                                #
  # #   onBoot = "ignore"; #do not automatically restart guests when host boots               #
  # #   onShutdown = "shutdown"; #tries to gracefully shutdown guests when hosts shuts down   #
  # # };                                                                                      #
  #############################################################################################
  #the GPU settings. hmm maybe i should have had that off?

  # GPU
  hardware.nvidia.prime = {
    sync.enable = true;
    #offload.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  #services.xserver.videoDrivers = [ "nvidia" ];


  # virtualisation settings

  # virtualisation = {
  #   # vfio settings - stuff related to vfio drivers
  #   vfio = {
  #     enable = true;
  #     IOMMUType = "intel";
  #     devices = [ "10de:1f36" "10de:10f9" ];
  #     blacklistNvidia = true;
  #     disableEFIfb = false; #unsure about this one
  #     ignoreMSRs = false; #also dunno about this one. seems CPU related which isnt my main issue atm
  #     applyACSpatch = false; #seems related to IOMMU grouping, which i think is fine, so ill leave it off for now
  #   };

  #   # libvirt - stuff related to KVM/QEMU
  #   libvirtd = {
  #     enable = true;
  #     qemuOvmf = true;
  #     clearEmulationCapabilities = false; #just the default, idk what this is
  #     # deviceACL = [
  #     #   "/dev/vfio/vfio"
  #     #   "/dev/vfio/1"
  #     #   "/dev/kvm"
  #     # ];
  #   };
  # };


  systemd.services.systemd-udev-settle.enable = false; #fixes one of the startup issues

  networking.hostId = "f1a2d797"; #machine id `head -c /etc/machine-id`
  networking.hostName = "syzygyzer"; # Define your hostname.
  #networking.wireless.enable = true;  # use networkmanager instead
  networking.networkmanager.enable = true; # enables NetworkManager service and nmtui

  # Set your time zone.
  time.timeZone = "US/Eastern";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp111s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
 
  fonts.fonts = with pkgs; [
    fira
    fira-code
    (nerdfonts.override { fonts = [ "Hack" ]; })
    powerline-fonts
  ]; 
 
  # ZFS services
  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.poprox = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "plugdev" "libvirtd" "transmission" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    brave
    coreutils
    dropbox-cli
    emacsPackages.emacsql-sqlite
    gcc
    gnumake
    gnupg
    libosinfo
    man
    mkpasswd
    networkmanager
    #nvidia-offload
    pcsclite
    pcsctools
    #pinentry-gnome
    sqlite
    steam
    steam-run-native
    tailscale
    testdisk
    transmission # torrent daemon
    tree
    vim
    virtmanager  #virtual machines
    wget
    yubikey-personalization
    yubioath-desktop

    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.xmonad
    haskellPackages.monad-logger
    haskellPackages.dbus
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.ssh.startAgent = false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    #pinentryFlavor = "curses";  #trying random shit to get this working
  };



  # services.gpg-agent.extraConfig = ''
  #   pinentry-program ${pkgs.pinentry.gnome3}/bin/pinentry-gnome3
  # '';

  # environment.variables = {
  #   GDK_SCALE = "2";
  #   GDK_DPI_SCALE = "0.5";
  #   QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  # };

  # List services that you want to enable:
  fonts.fontconfig.dpi=100;
  services = {
    dbus = {
      enable = true;
      socketActivated = true;
    };

    #X11 windowing system
    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [ "nvidia" ];
      dpi = 100;
      #xkbOptions = "eurosign:e";

      #startDbusSession = true; #no longer needed with 21.05
      libinput = { #touchpad
        enable = true;
        disableWhileTyping = true;
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmonad
          haskellPackages.monad-logger
          haskellPackages.dbus
        ];
      };

      #displayManager.sddm.enable = true;
      displayManager.lightdm.enable = true;
      #displayManager = pkgs.ly; #these don't work. how do i get ly?
      #displayManager.ly.enable = true;
      #
      #displayManager.defaultSession = "none+xmonad";
      desktopManager.plasma5.enable = true;

      #displayManager.autoLogin.enable = true;
      #displayManager.autoLogin.user = "poprox";

      # config = ''                                                                                  #
      # Section "Monitor"                                                                                  #
      #     Identifier  "eDP-1"                                                                            #
      #         Modeline "3840x2160_60.00"  712.75  3840 4160 4576 5312  2160 2163 2168 2237 -hsync +vsync #
      #         Option  "PreferredMode"  "3840x2160_60.00"                                                 #
      #         Option  "RightOf" "DP-2"                                                                   #
      #         Option  "Position" "3840 0"                                                                #
      # EndSection                                                                                         #
      #                                                                                                    #
      # Section "Monitor"                                                                                  #
      #     Identifier  "DP-2"                                                                             #
      #         Modeline "3440x1440_60.00"  419.50  3440 3696 4064 4688  1440 1443 1453 1493 -hsync +vsync #
      #         Option  "PreferredMode"  "3440x1440_60.00"                                                 #
      #         Option  "LeftOf" "eDP-1"                                                                   #
      # EndSection                                                                                         #
      #                                                                                                    #
      # Section "Screen"                                                                                   #
      #     Identifier "default Screen Section"                                                            #
      #     SubSection "Display"                                                                           #
      #         Virtual     7280 2160                                                                      #
      #     EndSubSection                                                                                  #
      # EndSection                                                                                         #
      # '';                                                                                                #

    };

    # torrent daemon
    transmission = {
      enable = true;
      settings = {
        download-dir = "/home/poprox/Downloads/torrents/";
        incomplete-dir = "/home/poprox/Downloads/torrents/incomplete/";
        incomplete-dir-enabled = true;
      };
    };

    #trezor
    trezord.enable = true;
  };

  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    man.enable = true;
    nixos.enable = true;
    nixos.includeAllModules = true;
  };

  #steam stuff
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = [
    pkgs.intel-ocl
    pkgs.vaapiIntel
    pkgs.vaapiVdpau
    pkgs.libvdpau-va-gl
  ];
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.steam-hardware.enable = true;
 

  # nonfree firmware
  hardware.enableRedistributableFirmware = true;

  #systemd
  systemd.services.upower.enable = true; #gets system power info such as CPU usage

  #dropbox
  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
  };
  serviceConfig = {
    ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
    ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
    KillMode = "control-group"; # upstream recommends process
    Restart = "on-failure";
    PrivateTmp = true;
    ProtectSystem = "full";
    Nice = 10;
    };
  };

  networking.extraHosts =
  ''
    #0.0.0.0 reddit.com
    #0.0.0.0 www.reddit.com
    #0.0.0.0 np.reddit.com
    0.0.0.0 www.facebook.com
    0.0.0.0 facebook.com
    #0.0.0.0 news.ycombinator.com
    0.0.0.0 www.twitter.com
    0.0.0.0 twitter.com
  '';

  services.tailscale.enable = true;

  #yubikey
  services.udev.packages = [ pkgs.yubikey-personalization pkgs.libu2f-host ];
  services.pcscd.enable = true;
 
  # development
  services.lorri.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';
  

  nix.nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
                  "nixos-config=/etc/nixos/configuration.nix"
                  "/nix/var/nix/profiles/per-user/root/channels"
                  "$HOME/.nix-defexpr/channels"
                ];

  
  environment.loginShellInit = ''
    export PATH="$HOME/.emacs.d/bin:$PATH"
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

