-- Automatically highlighting other uses of the word under the cursor
local M = {
  'RRethy/vim-illuminate',
  enabled = true,
  event = 'BufRead',
  opts = {
    delay = 200,
    filetypes_denylist = { 'alpha', 'neo-tree' },
    under_cursor = false,
  },
  config = function(_, opts)
    -- vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
    -- vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
    -- vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })
    require('illuminate').configure(opts)
  end
}

return M
