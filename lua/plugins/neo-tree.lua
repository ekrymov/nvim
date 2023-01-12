return {
  'nvim-neo-tree/neo-tree.nvim',
  cmd = 'Neotree',
  branch = 'v2.x',
  keys = {
    { '<leader>ft', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      window = {
        width = 25,
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = true,
        hijack_netrw_behavior = 'open_current',
      },
    }
  end
}
