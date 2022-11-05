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
      drawpile
      shotcut
      vlc
    ]) ++ (with unstable; [
      # Unstable packages

      # Media
      bitwig-studio          # 4.3+ features native pipewire support
      blender-hip            # Need at least 3.2+ to get HIP (AMD GPU accel.) support
      qpwgraph               # Want newer features and bugfixes

      # Communication
      cinny-desktop          # Latest version for bug reports
    ]);

    # Dotfile configuration
    xdg.enable = true;
    xdg.configFile = {
      # Powerlevel10K theme settings
      "powerlevel10k/p10k.zsh".source = ./dotfiles/powerlevel10k/p10k.zsh;
    };

    # Program-specific configuration
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      git = {
        enable = true;
        userName = "Andrew Morgan";
        userEmail = "1342360+anoadragon453@users.noreply.github.com";
     
        extraConfig = {
          init = {
	          defaultBranch = "main";
	        };
        };
      };

      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [ ];
      };

      zsh = {
        enable = true;
 
        # Enable autosuggestion support
        enableAutosuggestions = true;
 
        # Define any shell aliases
        shellAliases = { };
 
        # Enable shared-terminal history support
        history = {
          size = 10000;
        };
 
        initExtra = (
          # Source the generated powerlevel10k theme config
          "source ~/.config/powerlevel10k/p10k.zsh\n" +
          # Fix keybindings.
          # Taken from https://wiki.archlinux.org/title/Zsh
          ''
          # create a zkbd compatible hash;
          # to add other keys to this hash, see: man 5 terminfo
          typeset -g -A key
 
          key[Home]="''${terminfo[khome]}"
          key[End]="''${terminfo[kend]}"
          key[Insert]="''${terminfo[kich1]}"
          key[Backspace]="''${terminfo[kbs]}"
          key[Delete]="''${terminfo[kdch1]}"
          key[Up]="''${terminfo[kcuu1]}"
          key[Down]="''${terminfo[kcud1]}"
          key[Left]="''${terminfo[kcub1]}"
          key[Right]="''${terminfo[kcuf1]}"
          key[PageUp]="''${terminfo[kpp]}"
          key[PageDown]="''${terminfo[knp]}"
          key[Shift-Tab]="''${terminfo[kcbt]}"
 
          # setup various keys accordingly
          [[ -n "''${key[Home]}"      ]] && bindkey -- "''${key[Home]}"       beginning-of-line
          [[ -n "''${key[End]}"       ]] && bindkey -- "''${key[End]}"        end-of-line
          [[ -n "''${key[Insert]}"    ]] && bindkey -- "''${key[Insert]}"     overwrite-mode
          [[ -n "''${key[Backspace]}" ]] && bindkey -- "''${key[Backspace]}"  backward-delete-char
          [[ -n "''${key[Delete]}"    ]] && bindkey -- "''${key[Delete]}"     delete-char
          [[ -n "''${key[Up]}"        ]] && bindkey -- "''${key[Up]}"         up-line-or-search
          [[ -n "''${key[Down]}"      ]] && bindkey -- "''${key[Down]}"       down-line-or-search
          [[ -n "''${key[Left]}"      ]] && bindkey -- "''${key[Left]}"       backward-char
          [[ -n "''${key[Right]}"     ]] && bindkey -- "''${key[Right]}"      forward-char
          [[ -n "''${key[PageUp]}"    ]] && bindkey -- "''${key[PageUp]}"     beginning-of-buffer-or-history
          [[ -n "''${key[PageDown]}"  ]] && bindkey -- "''${key[PageDown]}"   end-of-buffer-or-history
          [[ -n "''${key[Shift-Tab]}" ]] && bindkey -- "''${key[Shift-Tab]}"  reverse-menu-complete
 
          # History search with up/down arrows
          autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
          zle -N up-line-or-beginning-search
          zle -N down-line-or-beginning-search
 
          # History search with Ctrl-R
          bindkey '^r' history-incremental-search-backward

          # Ctrl-A and Ctrl-E jump to beginning and end of line
          bindkey '^a' beginning-of-line
          bindkey '^e' end-of-line
 
          [[ -n "''${key[Up]}"   ]] && bindkey -- "''${key[Up]}"   up-line-or-beginning-search
          [[ -n "''${key[Down]}" ]] && bindkey -- "''${key[Down]}" down-line-or-beginning-search
 
          # Jump by word using Ctrl+arrow keys
          key[Control-Left]="''${terminfo[kLFT5]}"
          key[Control-Right]="''${terminfo[kRIT5]}"
 
          [[ -n "''${key[Control-Left]}"  ]] && bindkey -- "''${key[Control-Left]}"  backward-word
          [[ -n "''${key[Control-Right]}" ]] && bindkey -- "''${key[Control-Right]}" forward-word
 
          # Finally, make sure the terminal is in application mode, when zle is
          # active. Only then are the values from $terminfo valid.
          if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
            autoload -Uz add-zle-hook-widget
            function zle_application_mode_start { echoti smkx }
            function zle_application_mode_stop { echoti rmkx }
            add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
            add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
          fi
          '' +
          # Integrate direnv with zsh
          ''eval "''$(direnv hook zsh)"'' + "\n"
        );
 
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
    };
  };

  # Install packages to /etc/profiles.
  # Recommended to set by the home-manager guide (section 1.2).
  home-manager.useUserPackages = true;
  # Use the global system-level nixpkgs
  home-manager.useGlobalPkgs = true;

}
