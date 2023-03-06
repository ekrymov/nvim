return {
  'HiPhish/nvim-ts-rainbow2',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter.configs').setup {
      rainbow = {
        enable = true,
        disable = { 'cpp', 'go' },
        query = 'rainbow-parens',
        strategy = require('ts-rainbow.strategy.global'),
      },
    }
  end
}
