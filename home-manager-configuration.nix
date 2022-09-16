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

    # Dotfile configuration
    xdg.enable = true;

    # Powerlevel10K theme settings
    xdg.configFile."powerlevel10k/p10k.zsh".source = ./dotfiles/powerlevel10k/p10k.zsh;

    # Shell
    programs.zsh = {
      enable = true;

      # Enable autosuggestion support
      enableAutosuggestions = true;

      # Define any shell aliases
      shellAliases = { };

      # Enable shared-terminal history support
      history = {
        size = 10000;
      };

      # Source the generated powerlevel10k theme config
      initExtra = "source ~/.config/powerlevel10k/p10k.zsh";

      # Use the ZPlug plugin manager
      zplug = {
       enable = true;
       plugins = [
         # Extra zsh command completions
         { name = "zsh-users/zsh-completions"; tags = [ depth:1 ]; }
         # powerlevel10k zsh theme
         { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
       ];
     };
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

  # Change the default shell
  users.users.user.shell = pkgs.zsh;

  # Install packages to /etc/profiles.
  # Recommended to set by the home-manager guide (section 1.2).
  home-manager.useUserPackages = true;
  # Use the global system-level nixpkgs
  home-manager.useGlobalPkgs = true;

}
