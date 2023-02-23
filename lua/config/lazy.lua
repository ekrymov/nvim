-- Install lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load lazy
require('lazy').setup('plugins', {
  install = {
    colorscheme = {
      'catppuccin',
    },
  },
  -- defaults = { lazy = true },
  checker = {
    enabled = true,
    concurrency = 1,
  },
  debug = false,
})

