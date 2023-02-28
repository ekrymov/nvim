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
    },
  },
}

return M
