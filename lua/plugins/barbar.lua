return {
  'romgrk/barbar.nvim',
  enabled = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('bufferline').setup()
  end
}
