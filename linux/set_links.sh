#!/usr/bin/env bash
# Symlink tracked Linux configs into their expected locations.
# Run from this directory: ./set_links.sh
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  [ -e "$dst" ] && [ ! -L "$dst" ] && mv "$dst" "$dst.bak.$(date +%s)" && echo "backed up $dst"
  ln -sfn "$src" "$dst"
  echo "linked $dst -> $src"
}

# Shell (zsh)
link "$DIR/zshrc"    "$HOME/.zshrc"
link "$DIR/zshenv"   "$HOME/.zshenv"
link "$DIR/zprofile" "$HOME/.zprofile"

# tmux
link "$DIR/tmux.conf"            "$HOME/.config/tmux/tmux.conf"
link "$DIR/tmux.tokyonight.conf" "$HOME/.config/tmux/tmux.tokyonight.conf"

# bat (Ubuntu ships the binary as `batcat`; ~/.local/bin/bat shim added separately)
link "$DIR/bat" "$HOME/.config/bat"

# git
link "$DIR/gitconfig"  "$HOME/.gitconfig"
link "$DIR/git/ignore" "$HOME/.config/git/ignore"

# GitHub CLI — config only; the auth token in ~/.config/gh/hosts.yml stays local
link "$DIR/gh/config.yml" "$HOME/.config/gh/config.yml"

# yazi (file manager)
link "$DIR/yazi" "$HOME/.config/yazi"
