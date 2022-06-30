# NixOS Config

My [NixOS](https://nixos.org/) config files. Build my system in one command!

## Install

1. Install [NixOS](https://nixos.org/download.html) (the Linux distribution).
2. After installation, clone this repo to a folder in your user's home directory.
3. Run `./install.sh`.

Done!

For parts of the setup that aren't automated yet, see appropriate files under the [manual-setup](manual-setup/) directory.

## Notes

* Hardware configuration files - which are specific to each machine - are kept in the `hardware-configs` directory,
  and are **not installed** by `install.sh`.