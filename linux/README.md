# Linux (Ubuntu) environment configuration

Dotfiles for provisioning a remote Ubuntu box (built/tested on 24.04 "noble").
Counterpart to [`../macos`](../macos); the configs are adapted where the
platform differs (paths, package names, credential helper, shell location).

## One-shot install

```bash
./install.sh
```

Idempotent — safe to re-run. It installs everything below, symlinks the
configs, builds caches, and sets `zsh` as the login shell.

This box is **Homebrew-first**: apt installs only Homebrew's prerequisites and
the build toolchain; every user-facing tool comes from brew (newer than apt's,
and kept current with `brew upgrade`).

### What it does
- **apt** (prerequisites only): build-essential, procps, curl, file, git,
  ca-certificates, unzip
- **Homebrew** (Linuxbrew); its shellenv is loaded from `zprofile`
- **brew tools**: zsh, tmux, git, neovim, ripgrep, fd, bat, fzf, zoxide, lsd,
  git-delta, jq, btop, gh, lazygit, glow, doggo, dua-cli, yazi, and yazi's
  preview helpers (ffmpeg, poppler, imagemagick — v7, so `magick` works —
  sevenzip)
- **login shell**: brew's zsh, also symlinked to `/usr/bin/zsh` (see note below)
- **oh-my-zsh** + `zsh-autosuggestions` + `fast-syntax-highlighting`
- **tmux**: TPM + plugins (tmux-sensible, tmux-resurrect)
- **LazyVim**: clones the starter, symlinks our `lazyvim/` overlay, syncs
  plugins and treesitter parsers

> **Why the `/usr/bin/zsh` symlink matters:** brew's zsh lives at
> `/home/linuxbrew/.linuxbrew/bin/zsh`. tmux's `default-shell`, PAM, and any tool
> that launches `zsh` by its canonical path expect `/usr/bin/zsh`. `install.sh`
> symlinks it there. Don't `apt remove zsh` without that symlink in place — it
> deletes `/usr/bin/zsh` and breaks anything pinned to that path.

## Symlinks only

If the tools are already present and you just want the configs linked:

```bash
./set_links.sh
```

Links: zsh (`zshrc`/`zshenv`/`zprofile`), tmux, bat, git (+ global ignore),
gh (config only), yazi. Existing real files are backed up to `*.bak.<ts>`.

LazyVim is wired separately (see `install.sh`): `~/.config/nvim/lua` and
`~/.config/nvim/lazyvim.json` symlink back to `lazyvim/` here, while the rest of
`~/.config/nvim` (the starter, `lazy-lock.json`) stays local.

## Not handled automatically
- **gh auth**: run `gh auth login` after install. The token lives in
  `~/.config/gh/hosts.yml`, which is intentionally not tracked. The git
  credential helper for GitHub defers to `gh`, so this is required for pushes.
- **Nerd Font**: rendered by your *local* terminal, not the VPS — make sure the
  terminal you SSH from uses a Nerd Font so icons display.
- **Version managers** (rbenv, pyenv, fnm, bun, pnpm): initialized lazily by
  `zshrc` only when present; install them separately if needed.
