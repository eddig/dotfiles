#!/usr/bin/env bash
# Provision a fresh Ubuntu (24.04+) box to match this dotfiles setup.
# Homebrew-first: apt is used only for Homebrew's own prerequisites; every
# user-facing tool comes from brew (newer than apt, and `brew upgrade`-able).
# Idempotent: safe to re-run. Run from this directory: ./install.sh
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

have() { command -v "$1" >/dev/null 2>&1; }
log()  { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

# ── apt: Homebrew prerequisites + build toolchain only ───────────────────────
log "apt prerequisites"
sudo apt-get update -qq
sudo apt-get install -y build-essential procps curl file git ca-certificates unzip

# ── Homebrew (Linuxbrew) ─────────────────────────────────────────────────────
if [ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  log "Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ── brew packages (all user-facing tools) ────────────────────────────────────
log "brew packages"
brew install \
  zsh tmux git neovim \
  ripgrep fd bat fzf zoxide lsd git-delta jq btop \
  gh lazygit glow doggo dua-cli \
  yazi ffmpeg poppler imagemagick sevenzip   # yazi + its preview helpers

# ── make brew zsh the login shell ────────────────────────────────────────────
# IMPORTANT: also expose it at /usr/bin/zsh. Tools, PAM, and tmux's default-shell
# expect zsh at the canonical path; without this symlink, removing apt's zsh
# leaves nothing at /usr/bin/zsh and anything launching `zsh` there breaks.
BREW_ZSH="$(brew --prefix)/bin/zsh"
grep -qxF "$BREW_ZSH" /etc/shells || echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
sudo ln -sfn "$BREW_ZSH" /usr/bin/zsh
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$BREW_ZSH" ]; then
  log "setting default shell to brew zsh"
  sudo chsh -s "$BREW_ZSH" "$USER"
fi

# ── oh-my-zsh + plugins ──────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
  git clone -q --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ] || \
  git clone -q --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"

# ── tmux plugin manager ──────────────────────────────────────────────────────
TPM="$HOME/.config/tmux/plugins/tpm"
[ -d "$TPM" ] || git clone -q --depth=1 https://github.com/tmux-plugins/tpm "$TPM"

# ── symlink configs ──────────────────────────────────────────────────────────
log "linking configs"
"$DIR/set_links.sh"

# ── caches + plugins ─────────────────────────────────────────────────────────
bat cache --build >/dev/null 2>&1 || true
"$TPM/bin/install_plugins" >/dev/null 2>&1 || true

# ── LazyVim: starter + our overlay (symlinked, so the overlay stays tracked) ──
# Note: the full nvim dir is NOT symlinked (lazy writes lazy-lock.json there);
# only lua/ and lazyvim.json point back at this repo.
NVIM_CFG="$HOME/.config/nvim"
if [ ! -e "$NVIM_CFG/init.lua" ]; then
  log "LazyVim starter"
  git clone -q --depth=1 https://github.com/LazyVim/starter "$NVIM_CFG"
  rm -rf "$NVIM_CFG/.git"
fi
rm -rf "$NVIM_CFG/lua"
ln -sfn "$DIR/lazyvim/lua"          "$NVIM_CFG/lua"
ln -sfn "$DIR/lazyvim/lazyvim.json" "$NVIM_CFG/lazyvim.json"
if have nvim; then
  log "syncing LazyVim plugins + treesitter parsers (first run is slow)"
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
  nvim --headless "+lua local h=require('nvim-treesitter').install({'lua','vim','vimdoc','bash','markdown','markdown_inline','json','yaml','toml','rust','typescript','tsx','javascript','python','query','regex','c','diff','html','css'}); if h and h.wait then h:wait(600000) end" +qa 2>/dev/null || true
fi

log "done — open a new login shell, then run: gh auth login"
