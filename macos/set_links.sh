#!/usr/bin/env bash
# Symlink tracked configs into their expected locations.
# Run from this directory: ./set_links.sh
PWD=$(pwd)

# Shell (zsh)
ln -s $PWD/zshrc ~/.zshrc
ln -s $PWD/zshenv ~/.zshenv
ln -s $PWD/zprofile ~/.zprofile

# Git
ln -s $PWD/gitconfig ~/.gitconfig
mkdir -p ~/.config/git
ln -s $PWD/git/ignore ~/.config/git/ignore

# tmux
mkdir -p ~/.config/tmux
ln -s $PWD/tmux.conf ~/.config/tmux/tmux.conf
ln -s $PWD/tmux.tokyonight.conf ~/.config/tmux/tmux.tokyonight.conf

# bat
ln -s $PWD/bat ~/.config/bat

# lazygit
mkdir -p ~/Library/"Application Support"/lazygit
ln -s $PWD/lazygit.yml ~/Library/"Application Support"/lazygit/config.yml

# ghostty (terminal)
ln -s $PWD/ghostty ~/.config/ghostty

# yazi (file manager)
ln -s $PWD/yazi ~/.config/yazi

# GitHub CLI — config only; the auth token in ~/.config/gh/hosts.yml stays local
mkdir -p ~/.config/gh
ln -s $PWD/gh/config.yml ~/.config/gh/config.yml
