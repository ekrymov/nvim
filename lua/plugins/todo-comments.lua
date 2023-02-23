-- Highlight TODO, FIX, BUG etc.
local M = {
  'folke/todo-comments.nvim',
  event = 'BufRead',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>]',
      function()
        require('todo-comments').jump_next()  
      end,
      desc = 'Next todo comment',
    },
    {
      '<leader>[',
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
  config = function(_, opts)
    require('todo-comments').setup(opts)
  end
}

return M
