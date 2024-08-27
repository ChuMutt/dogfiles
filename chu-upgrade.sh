#!/bin/sh
# Change into dotfiles dir root
pushd ~/.config/dogfiles
# Run this in dotfiles dir root
# This also applies user configuration in tow (i.e., home-mananger's home.nix and username.nix).
sudo nixos-rebuild switch --flake ./#default
# Pop back out of dotfiles dir
popd
