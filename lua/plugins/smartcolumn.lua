return {
  'm4xshen/smartcolumn.nvim',
  event = 'BufEnter',
  opts = {
    colorcolumn = 100,
    disabled_filetypes = {
      'help',
      'text',
      'alpha',
      'dashboard',
      'neo-tree',
      'lazy',
      'mason',
    },
  },
}
