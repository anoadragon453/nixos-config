# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      /etc/nixos/amd-hardware-configuration.nix
      /etc/nixos/home-manager-configuration.nix
      # Drive home manager via the system configuration
      <home-manager/nixos>
      # Audio production related options
      <musnix>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Kernel

  # Configure the kernel for high-performance audio-production
  musnix.kernel.optimize = true;
  musnix.kernel.realtime = true;

  # Extra kernel modules
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude some GNOME packages from being installed
  # Full list: https://github.com/NixOS/nixpkgs/blob/release-22.05/nixos/modules/services/x11/desktop-managers/gnome.nix#L483
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    atomix    # puzzle game
    epiphany  # web browser
    geary     # email reader
    hitori    # sudoku game
    iagno     # go game
    tali      # poker games
    totem     # gnome videos
  ]);

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager
    media-session.enable = true;
    wireplumber.enable = false;
  };

  # Configure various settings for a better audio production experience.
  # See https://github.com/musnix/musnix
  musnix.enable = true;
  musnix.soundcardPciId = "00:1f.3";
  musnix.das_watchdog.enable = true;

  # Automatically garbage collect the nix store
  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  # Set global system environment variables
  environment.sessionVariables = {
    # Enable smooth-scrolling in Mozilla apps
    MOZ_USE_XINPUT2 = "1";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Violet Ray";
    extraGroups = [ "adbusers" "audio" "docker" "networkmanager" "wheel" ];
  };

  # Define zsh as a known shell.
  # Required for GDM to show user accounts that use these shells.
  environment.shells = with pkgs; [ zsh ];

  # Allow zsh to complete options for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    # Terminal tools
    direnv
    docker-compose_2  # Rename to docker-compose upon upgrading to next nixos release
    dnsutils
    file
    fd
    ffmpeg
    gcc
    ghostscript
    git
    htop
    imagemagick
    magic-wormhole
    ncdu
    pciutils
    ripgrep
    tmux
    wget
    yt-dlp

    # Libraries
    libfido2   # for yubikey FIDO auth

    # Gnome extensions
    # These need to be enabled manually in the "Extensions" app after install
    gnomeExtensions.caffeine
    gnomeExtensions.fullscreen-notifications
    gnomeExtensions.gsconnect
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.tray-icons-reloaded

    # Internet
    firefox
    mullvad-vpn
    qbittorrent
    tor-browser-bundle-bin

    # Media
    droidcam
    helvum
    jitsi-meet-electron
    kdenlive
    krita
    mpv
    pavucontrol

    # Misc
    meslo-lgs-nf  # patched nerd fonts for powerlevel10k

    # Tools
    android-studio
    android-tools
    cachix
    emote
    gnome.gnome-tweaks
    kid3
    rustup
    usbutils
    wineWowPackages.stableFull
    xournalpp
    yabridge
    yabridgectl
  ]) ++ (with unstable; [
    # Unstable packages

    # Fix GNOME bug with alt-tab. Only available in unstable currently
    gnomeExtensions.alttab-scroll-workaround
  ]);

  # Enable nix flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      # Enable flakes
      experimental-features = nix-command flakes

      # Prevent nix-direnv packages from being garbage collected
      # From https://github.com/nix-community/nix-direnv README
      keep-outputs = true
      keep-derivations = true
    '';

    settings = {
      # Saves quite a lot of disk space
      auto-optimise-store = true;
    };
  };

  # Specific program configuration
  programs = {
    # Android device bridge
    adb.enable = true;

    # Required to allow users to use the zsh shell
    zsh.enable = true;

    # Enable neovim and set it as the default everywhere
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = true;
    };

    # To enable YubiKey SSH auth
    ssh.startAgent = false;

    # Steam
    # Will implicitly enable hardware.steam-hardware.
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable support for flatpak applications
  services.flatpak.enable = true;

  # PC/SC Smart Card Daemon, for yubikey access
  services.pcscd.enable = true;

  # Allow mullvad vpn daemon.
  # Will set networking.firewall.checkReversePath to "loose"
  services.mullvad-vpn.enable = true;

  # Enable the docker daemon
  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.allowedTCPPortRanges = [
    # KDEConnect/gsconnect
    { from = 1716; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDEConnect/gsconnect
    { from = 1716; to = 1764; }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
