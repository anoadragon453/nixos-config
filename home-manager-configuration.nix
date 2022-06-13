# home-manager user profile configuration
{ config, lib, pkgs, modulesPath, ... }:

{

  # Configure the "user" user.
  home-manager.users.user = { pkgs, ... }: {
    # The packages to install for this user
    home.packages = with pkgs; [
      # Communication
      discord
      element-desktop
      signal-desktop
      thunderbird
      joplin-desktop

      # Development
      vscode
      jetbrains.pycharm-community

      # Tools
      #gnome.gnome-boxes

      # Internet
      qbittorrent

      # Media
      bitwig-studio
      blender
      drawpile
      davinci-resolve
      qjackctl
      vlc
    ];

    # Shell
    programs.fish = {
      enable = true;
      shellAliases = { };
    };

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

  # Use fish as the default shell
  users.users.user.shell = pkgs.fish;

  # Install packages to /etc/profiles.
  # Recommended to set by the home-manager guide (section 1.2).
  home-manager.useUserPackages = true;
  # Use the global system-level nixpkgs
  home-manager.useGlobalPkgs = true;

}
