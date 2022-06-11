#!/bin/sh
# Backup existing /etc/configuration.nix
sudo mv /etc/nixos/{configuration,configuration-old}.nix

# Symlink all top-level *.nix files
for filename in *.nix; do
  sudo ln -s "$PWD/$filename" "/etc/nixos/$filename"
done

echo "Configuration symlinked. Running 'nixos-rebuild switch'"

sudo nixos-rebuild switch

echo "Done!"
