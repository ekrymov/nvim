M = {
  'glepnir/lspsaga.nvim',
  enabled = false,
  event = 'BufRead',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  config = function()
    require('lspsaga').setup {
      ui = {
        colors = {
          normal_bg = '#2e1e4e',
        },
      },
      lightbulb = {
        enable = false,
      },
    }
  end
}

return M