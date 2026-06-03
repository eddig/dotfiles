-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- No need backup or swap as there is git
vim.o.backup = false
vim.o.swapfile = false
vim.o.writebackup = false

-- Disable all animations
vim.g.snacks_animate = false

-- Use normal line numbers order
vim.o.relativenumber = false

-- Sync yank/delete/put with the system clipboard.
-- Over SSH, LazyVim leaves 'clipboard' empty so its OSC 52 fallback works; we
-- override that here. Inside tmux, Neovim copies via `tmux load-buffer -w -`,
-- which relays to the local clipboard over OSC 52 and pastes from the local
-- tmux buffer (no slow OSC 52 read), so unnamedplus is safe here.
vim.o.clipboard = "unnamedplus"

-- Custom clipboard provider so we never issue an OSC 52 clipboard *read*.
-- Neovim's default tmux provider pastes via `tmux refresh-client -l`, which
-- queries the outer terminal's clipboard over OSC 52 -> Ghostty pops up its
-- "an application is attempting to read from the clipboard" prompt on startup.
-- Copy still relays out to the local clipboard via `load-buffer -w` (OSC 52
-- *write*, allowed silently); paste reads only the local tmux buffer.
vim.g.clipboard = {
  name = "tmux-no-osc52-read",
  copy = {
    ["+"] = { "tmux", "load-buffer", "-w", "-" },
    ["*"] = { "tmux", "load-buffer", "-w", "-" },
  },
  paste = {
    ["+"] = { "sh", "-c", "tmux save-buffer - 2>/dev/null" },
    ["*"] = { "sh", "-c", "tmux save-buffer - 2>/dev/null" },
  },
  cache_enabled = 0,
}

-- Adjust the bufferline background color to look better with the tokyonight colorscheme
vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#24283b" })
