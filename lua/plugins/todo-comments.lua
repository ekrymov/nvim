-- Highlight TODO, FIX, BUG etc.
local M = {
  'folke/todo-comments.nvim',
  event = 'BufRead',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      ']t',
      function()
        require('todo-comments').jump_next()  
      end,
      desc = 'Next todo comment',
    },
    {
      '[t',
      function()
        require('todo-comments').jump_prev()
      end,
      desc = 'Previous todo comment',
    },
  },
  opts = {
    highlight = {
      multiline = false,
    },
  },
}

return M
