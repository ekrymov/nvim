-- Neorg (New Life Organization Tool)
M = {
  'nvim-neorg/neorg',
  enabled = true,
  dependencies = { 'nvim-lua/plenary.nvim' },
  build = ':Neorg sync-parsers',
  opts = {
    load = {
      ['core.defaults'] = {},
      ['core.norg.concealer'] = {},
      ['core.norg.dirman'] = {
        config = {
          workspaces = {
            home = '~/.norg/home',
            work = '~/.norg/work',
          },
          default_workspace = 'work',
        },
      },
      ['core.keybinds'] = {
        config = {
          --default_keybinds = false,
          hook = function(keybinds)
            --keybinds.map('norg', 'n', '<leader>nn', 'core.norg.dirman.new.note')
            keybinds.remap_key('norg', 'n', '<leader>mn', '<leader>nm')
            keybinds.remap_key('norg', 'n', '<leader>mh', '<leader>nh')
          end
        },
      },
    },
  },
}

return M
