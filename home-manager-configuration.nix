# home-manager user profile configuration
{ config, lib, pkgs, modulesPath, ... }:

{

  # Configure the "user" user.
  home-manager.users.user = { pkgs, ... }: {
    # The packages to install for this user
    home.packages = [
      # Communication
      pkgs.discord
      pkgs.element-desktop
      pkgs.signal-desktop
      pkgs.thunderbird
      pkgs.joplin-desktop

      # Development
      pkgs.vscode
      pkgs.jetbrains.pycharm-community

      # Tools
      #pkgs.gnome.gnome-boxes

      # Internet
      pkgs.qbittorrent

      # Media
      pkgs.bitwig-studio
      pkgs.blender
      pkgs.davinci-resolve
      pkgs.qjackctl
      pkgs.vlc
    ];

    # Shell
    programs.fish.enable = true;

    # OBS
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [ ];
    };

    # Git config
    programs.git = {
      enable = true;
      userName = "Andrew Morgan";
      userEmail = "andrew@amorgan.xyz";

      extraConfig = {
        init = {
	  defaultBranch = "main";
	};
      };
    };
  };

  # Install packages to /etc/profiles.
  # Recommended to set by the home-manager guide (section 1.2).
  home-manager.useUserPackages = true;
  # Use the global system-level nixpkgs
  home-manager.useGlobalPkgs = true;

}
