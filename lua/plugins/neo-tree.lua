return {
  'nvim-neo-tree/neo-tree.nvim',
  cmd = 'Neotree',
  branch = 'v2.x',
  keys = {
    { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'Explorer Toggle' },
    { '<leader>o', '<cmd>Neotree focus<cr>', desc = 'Explorer Focus' },
    { '<leader>bb', '<cmd>Neotree buffers reveal float<cr>', desc = 'Show Buffers' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true,
      window = {
        width = 25,
        mappings = {
          ['<space>'] = false, -- disable space until we figure out which-key disabling
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = {
            'node_modules',
          },
          always_show = {
            '.gitignore',
          },
          never_show = {
            '.DS_Store',
          },
        },
        follow_current_file = true,
        hijack_netrw_behavior = 'open_current',
        window = {
          mappings = {
            h = 'toggle_hidden',
          },
        },
      },
    }
  end
}
