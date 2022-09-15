# home-manager user profile configuration
{ config, lib, pkgs, modulesPath, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {

  # Configure the "user" user.
  home-manager.users.user = { pkgs, ... }: {
    # The packages to install for this user
    home.packages = (with pkgs; [
      # Communication
      discord
      element-desktop
      signal-desktop
      thunderbird
      joplin-desktop

      # Development
      vscode
      jetbrains.pycharm-community
      jetbrains.webstorm

      # Tools
      gnome.gnome-boxes

      # Internet
      chromium
      qbittorrent

      # Media
      blender
      drawpile
      qjackctl
      shotcut
      vlc
    ]) ++ (with unstable; [
      # Unstable packages

      # Media
      bitwig-studio

      # Communication
      cinny-desktop
    ]);

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
      userEmail = "1342360+anoadragon453@users.noreply.github.com";

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
