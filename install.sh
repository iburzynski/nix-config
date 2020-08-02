#! /usr/bin/env bash

# Shows the output of every command
set +x

# Pin Nixpkgs to NixOS unstable on July 25th of 2020
export PINNED_NIX_PKGS="https://github.com/NixOS/nixpkgs-channels/archive/5717d9d2f7c.tar.gz"

# Switch to the unstable channel
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nixos-rebuild -I nixpkgs=$PINNED_NIX_PKGS switch --upgrade

# Nix configuration
sudo cp system/configuration.nix /etc/nixos/
sudo mkdir -p /etc/nixos/machine/
sudo cp system/machine/* /etc/nixos/machine/
mkdir -p $HOME/.config/nixpkgs/
cp -r nixos/home/* $HOME/.config/nixpkgs/

# Home manager
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install
cp nixos/home/nixos.png $HOME/Pictures/
home-manager switch

# Set user's profile picture for Gnome3
sudo cp nixos/home/gvolpe.png /var/lib/AccountsService/icons/gvolpe
sudo echo "Icon=/var/lib/AccountsService/icons/gvolpe" >> /var/lib/AccountsService/users/gvolpe
