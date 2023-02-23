local M = {
  'folke/trouble.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  keys = {
    { '<leader>lt', '<cmd>TroubleToggle<cr>', desc = 'Trouble toggle' },
  },
  config = true,
}

return M
