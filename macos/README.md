# macOS environment configuration

Dotfiles for provisioning a new macOS machine.

## Install order

### 1. Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Packages
Installs every tracked formula and cask:
```bash
brew bundle --file=Brewfile
```

### 3. oh-my-zsh
Required by `zshrc`:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 4. Symlink configs
```bash
./set_links.sh
```
Links: zsh, git (+ global ignore), tmux, bat, lazygit, ghostty, yazi, gh (config only).

### 5. Patched fonts
Fonts with the additional emoji glyphs. Taken from the [repo](https://github.com/2players/sfmono-nerd-font)
```bash
cp fonts/*/* ~/Library/Fonts/
```

## Not handled automatically
- **Neovim**: install the [LazyVim starter](https://www.lazyvim.org/installation), then copy the `lazyvim/lua` overlay into `~/.config/nvim/lua` manually (symlinking the full nvim dir does not work).
- **gh auth**: run `gh auth login` after step 4. The token lives in `~/.config/gh/hosts.yml`, which is intentionally not tracked.
- **Version managers**: rbenv, pyenv, fnm, bun, nvm and cargo are initialized by the shell config and installed separately (most are in the Brewfile).
