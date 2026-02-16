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

-- Adjust the bufferline background color to look better with the tokyonight colorscheme
vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#24283b" })
