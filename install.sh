#!/bin/sh
# A script to automatically apply my config on NixOS.

# We need to know the current NixOS release version
VERSION_INFO=`nixos-version`
# Extract just the release number (there would ideally just be a flag for this...)
NIXOS_RELEASE=${VERSION_INFO:0:5}

# Add necessary channels.
echo "Adding channels..."

# Add home-manager channel to install home-manager from.
# This is done as root as we'll be managing home-manager from the system configuration.
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-$NIXOS_RELEASE.tar.gz home-manager
# Add the musnix channel, enabling simple configuration of audio-production related options.
sudo nix-channel --add https://github.com/musnix/musnix/archive/master.tar.gz musnix

echo "Symlinking configuration files..."

# Backup existing /etc/configuration.nix
sudo mv /etc/nixos/{configuration,configuration-old}.nix

# Symlink all top-level *.nix files
for filename in *.nix; do
  sudo ln -s "$PWD/$filename" "/etc/nixos/$filename"
done

echo "Running 'nixos-rebuild switch'..."

sudo nixos-rebuild switch

# Install flatpak apps
# TODO: How to do this via nix?
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install discord
flatpak install discord-screenaudio

echo "Done! It is recommended to reboot."
