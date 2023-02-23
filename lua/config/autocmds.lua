local is_available = require('utils').is_available
local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
cmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = augroup('YankHighlight', { clear = true }),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

if is_available('neo-tree.nvim') then
  cmd('BufEnter', {
    desc = 'Open Neo-Tree on startup with directory',
    group = augroup('neotree_start', { clear = true }),
    callback = function()
      local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
      if stats and stats.type == 'directory' then
        require('neo-tree.setup.netrw').hijack()
      end
    end,
  })
end

-- Save session every time a buffer is written
if is_available('neovim-session-manager') then
  cmd('BufWritePost', {
    group = augroup('session_manager', {}),
    callback = function()
      if vim.bo.filetype ~= 'git' and not vim.bo.filetype ~= 'gitcommit' then
        require('session_manager').autosave_session()
      end
    end,
  })
end