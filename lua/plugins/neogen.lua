-- Annotation toolkit
local M = {
  'danymat/neogen',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  keys = {
    {
      '<leader>ga',
      function()
        require('neogen').generate()
      end,
      desc = 'Generate annotation',
    },
  },
  opts = {
    snippet_engine = 'luasnip',
  },
}

return M
