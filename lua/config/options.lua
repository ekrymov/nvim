-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.shortmess:append { s = true, I = true } -- disable startup message
vim.o.scrolloff = 8 -- Number of lines to keep above and below the cursor
vim.wo.relativenumber = false -- Disable relative numberline
vim.wo.wrap = false -- Disable wrapping of lines longer than the width of window
vim.g.autoformat_enabled = true -- enable or disableauto formatting at start (lsp.formatting.format_on_save must be enabled)
vim.g.autopairs_enabled = true -- enable autopairs at start
vim.g.cmp_enabled = true -- enable completion at start
vim.g.diagnostics_enabled = true -- enable diagnostics at start
vim.g.status_diagnostics_enabled = true -- enable diagnostics at statusline
vim.g.ui_notifications_enabled = true -- disable notifications when toggling UI elements

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

-- Highlight cursor line
vim.o.cursorline = true

-- Indent
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.autoindent = true

-- Disable providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Clipboard
vim.o.clipboard = 'unnamedplus'

-- Swapfile off
vim.o.swapfile = false

-- pop up menu height
vim.o.pumheight = 10

-- we don't need to see things like -- INSERT -- anymore
vim.o.showmode = false

-- how many lines to scroll when using the scrollbar
vim.o.sidescrolloff = 5

vim.o.sessionoptions = 'buffers,curdir,folds,help,tabpages,terminal,globals'

vim.o.expandtab = true

vim.o.termguicolors = true

vim.o.writebackup = false

vim.o.jumpoptions = 'view'

vim.o.cmdheight = 0

vim.o.list = true

vim.o.splitkeep = 'screen'

vim.o.spelloptions = 'camel,noplainbuffer'

vim.o.foldlevel = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = true