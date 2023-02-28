local set_mappings = require('utils').set_mappings
local is_available = require('utils').is_available
local ui = require('utils.ui')
local map = vim.keymap.set

local maps = { i = {}, n = {}, v = {}, t = {} }

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
--map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Back to normal mode from <jk>
map('i', 'jk', '<Esc>', { noremap = true })

-- Move lines
map('n', '<C-M-j>', ':m .+1<CR>==', { desc = 'Move down' })
map('n', '<C-M-k>', ':m .-2<CR>==', { desc = 'Move up' })



-- Maps from AstroNvim

-- Standart operation
maps.n['<leader>w'] = { '<cmd>w<cr>', desc = 'Save'}
maps.n['<leader>q'] = { '<cmd>q<cr>', desc = 'Quit'}
maps.n['<leader>fn'] = { '<cmd>enew<cr>', desc = 'New File'}

-- Manage buffers
if is_available('barbar.nvim') then
  maps.n['<leader>c'] = { '<cmd>BufferClose<cr>', desc = 'Close buffer' }
  maps.n['<leader>C'] = { '<cmd>BufferClose!<cr>', desc = 'Force close buffer' }
  maps.n['<S-l>'] = { '<cmd>BufferNext<cr>', desc = 'Next buffer' }
  maps.n['<S-h>'] = { '<cmd>BufferPrevious<cr>', desc = 'Previous buffer' }
  maps.n['>b'] = { '<cmd>BufferMoveNext<cr>', desc = 'Move buffer tab right' }
  maps.n['<b'] = { '<cmd>BufferMovePrevious<cr>', desc = 'Move buffer tab left' }
  maps.n['<leader>bn'] = { '<cmd>BufferPick<cr>', desc = 'Pick buffers' }
  maps.n['<leader>bp'] = { '<cmd>BufferPin<cr>', desc = 'Pin/unpin buffer' }
else
  maps.n['<leader>c'] = { '<cmd>bdelete<cr>', desc = 'Close buffer' }
  maps.n['<leader>C'] = { '<cmd>bdelete!<cr>', desc = 'Force close buffer' }
  maps.n[']b'] = { '<cmd>bnext<cr>', desc = 'Next buffer' }
  maps.n['[b'] = { '<cmd>bprevious<cr>', desc = 'Previous buffer' }
end

-- Lazy.nvim
local lazy = require('lazy')
maps.n['<leader>ph'] = { function() lazy.health() end, desc = 'Lazy Checkhealth' }
maps.n['<leader>pi'] = { function() lazy.home() end, desc = 'Lazy Home' }
maps.n['<leader>ps'] = { function() lazy.sync() end, desc = 'Lazy Sync' }
maps.n['<leader>pl'] = { function() lazy.log() end, desc = 'Lazy Log' }
maps.n['<leader>pu'] = { function() lazy.update() end, desc = 'Lazy Update' }

-- Dashboard
if is_available('alpha-nvim') then
  maps.n['<leader>d'] = { function() require('alpha').start() end, desc = 'Dashboard home' }
elseif is_available('dashboard-nvim') then
  maps.n['<leader>d'] = { '<cmd>Dashboard<cr>', desc = 'Dashboard home' }
end

-- Comment.nvim
if is_available('Comment.nvim') then
  maps.n['<leader>/'] = {
    function() require('Comment.api').toggle.linewise.current() end,
    desc = 'Comment line',
  }
  maps.v['<leader>/'] = {
    "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    desc = 'Toggle comment line',
  }
end

-- GitSigns
if is_available('gitsigns.nvim') then
  local gs = require('gitsigns')
  maps.n['<leader>gj'] = { function() gs.next_hunk() end, desc = 'Next Git hunk' }
  maps.n['<leader>gk'] = { function() gs.prev_hunk() end, desc = 'Previous Git hunk' }
  maps.n['<leader>gl'] = { function() gs.blame_line() end, desc = 'View Git blame' }
  maps.n['<leader>gp'] = { function() gs.preview_hunk() end, desc = 'Preview Git hunk' }
  maps.n['<leader>gh'] = { function() gs.reset_hunk() end, desc = 'Reset Git hunk' }
  maps.n['<leader>gr'] = { function() gs.reset_buffer() end, desc = 'Reset Git buffer' }
  maps.n['<leader>gs'] = { function() gs.stage_hunk() end, desc = 'Stage Git hunk' }
  maps.n['<leader>gu'] = { function() gs.undo_stage_hunk() end, desc = 'Unstage Git hunk' }
  maps.n['<leader>gd'] = { function() gs.diffthis() end, desc = 'View Git diff' }
end

-- Mason.nvim
if is_available('mason.nvim') then
  maps.n['<leader>pI'] = { '<cmd>Mason<cr>', desc = 'Mason Installer' }
  maps.n['<leader>pU'] = { '<cmd>MasonUpdateAll<cr>', desc = 'Mason Update' }
end

-- Telescope
if is_available('telescope.nvim') then
  local tb = require('telescope.builtin')
  maps.n['<leader>fw'] = { function() tb.live_grep() end, desc = 'Search words' }
  maps.n['<leader>fW'] = {
    function()
      tb.live_grep {
        additional_args = function(args) return vim.list_extend(args, { '--hidden', '--no-ignore' }) end,
      }
    end,
    desc = 'Search words in all files',
  }
  maps.n['<leader>ff'] = { function() tb.find_files() end, desc = 'Search files' }
  maps.n['<leader>fF'] = {
    function() tb.find_files { hidden = true, no_ignore = true } end,
    desc = 'Search all files',
  }
  maps.n['<leader>fb'] = { function() tb.buffers() end, desc = 'Search buffers' }
  maps.n['<leader>fh'] = { function() tb.help_tags() end, desc = 'Search help' }
  maps.n['<leader>fm'] = { function() tb.marks() end, desc = 'Search marks' }
  maps.n['<leader>fo'] = { function() tb.oldfiles() end, desc = 'Search history' }
  maps.n['<leader>fc'] = {
    function() tb.grep_string() end, desc = 'Search for word under cursor',
  }
  -- git
  maps.n['<leader>gt'] = { function() tb.git_status() end, desc = 'Git status' }
  maps.n['<leader>gb'] = { function() tb.git_branches() end, desc = 'Git branches' }
  maps.n['<leader>gc'] = { function() tb.git_commits() end, desc = 'Git commits' }
  -- 
  maps.n['<leader>sb'] = { function() tb.git_branches() end, desc = 'Git branches' }
  maps.n['<leader>sh'] = { function() tb.help_tags() end, desc = 'Search help' }
  maps.n['<leader>sm'] = { function() tb.man_pages() end, desc = 'Search man' }
  maps.n['<leader>sr'] = { function() tb.registers() end, desc = 'Search registers' }
  maps.n['<leader>sk'] = { function() tb.keymaps() end, desc = 'Search keymaps' }
  maps.n['<leader>sc'] = { function() tb.commands() end, desc = 'Search commands' }
  maps.n['<leader>sf'] = { 
    function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      tb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end,
    desc = 'Current buffer fuzzy search',
  }
  maps.n['<leader>sn'] = {
    function() require('telescope').extensions.notify.notify() end,
    desc = 'Search notifications',
  }
end

-- Neovim-sessions manager
if is_available('neovim-session-manager') then
  maps.n['<leader>Sl'] = { '<cmd>SessionManager! load_last_session<cr>', desc = 'Load last session' }
  maps.n['<leader>Ss'] = { '<cmd>SessionManager! save_current_session<cr>', desc = 'Save this session' }
  maps.n['<leader>Sd'] = { '<cmd>SessionManager! delete_session<cr>', desc = 'Delete session' }
  maps.n['<leader>Sf'] = { '<cmd>SessionManager! load_session<cr>', desc = 'Search session' }
  maps.n['<leader>S.'] = {
    '<cmd>SessionManager! load_current_dir_session<cr>', desc = 'Load current directory session',
  }
end

-- Toggleterm
if is_available('toggleterm.nvim') then
  local tt_cmd = require('utils').toggleterm_cmd
  if vim.fn.executable('lazygit') == 1 then
    maps.n['<leader>tl'] = { function() tt_cmd('lazygit') end, desc = 'ToggleTerm lazygit' }
    maps.n['<leader>gg'] = { function() tt_cmd('lazygit') end, desc = 'ToggleTerm lazygit' }
  end
  if vim.fn.executable('node') == 1 then
    maps.n['<leader>tn'] = { function() tt_cmd('node') end, desc = 'ToggleTerm node' }
  end
  if vim.fn.executable('gdu') == 1 then
    maps.n['<leader>tu'] = { function() tt_cmd('gdu') end, desc = 'ToggleTerm gdu' }
  end
  if vim.fn.executable('btm') == 1 then
    maps.n['<leader>tt'] = { function() tt_cmd('btm') end, desc = 'ToggleTerm btm' }
  end
  if vim.fn.executable('python3') == 1 then
    maps.n['<leader>tp'] = { function() tt_cmd('python3') end, desc = 'ToggleTerm python' }
  end
  maps.n['<leader>tf'] = { '<cmd>ToggleTerm direction=float<cr>', desc = 'ToggleTerm float' }
  maps.n['<leader>th'] = {
    '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'ToggleTerm horizontal split',
  }
  maps.n['<leader>tv'] = {
    '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'ToggleTerm vertical split',
  }
end

-- nvim-autopairs
if is_available('nvim-autopairs') then
  maps.n['<leader>ua'] = { function() ui.toggle_autopairs() end, desc = 'Toggle autopairs' }
end

-- nvim-cmp
if is_available('nvim-cmp') then
  maps.n['<leader>uc'] = { function() ui.toggle_cmp() end, desc = 'Toggle autocompletion' }
end

maps.n['<leader>ud'] = {
  function() require('utils.ui').toggle_diagnostics() end, desc = 'Toggle diagnostics'
}

maps.n['<leader>un'] = { function() ui.change_number() end, desc = 'Change line numbering' }
maps.n['<leader>uw'] = { function() ui.toggle_wrap() end, desc = 'Toggle wrap' }
maps.n['<leader>up'] = { function() ui.toggle_paste() end, desc = 'Toggle paste mode' }

set_mappings(maps)