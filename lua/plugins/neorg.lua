-- Neorg (New Life Organization Tool)
M = {
  'nvim-neorg/neorg',
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
        },
      },
      ['core.keybinds'] = {
        config = {
          default_keybinds = false,
        },
      },
    },
  },
}

return M
