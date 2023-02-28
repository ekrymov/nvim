return {
  { -- Catppiccin theme
    'catppuccin/nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({ flavour = 'mocha' }) -- latte, frappe, macchiato, mocha
      vim.cmd.colorscheme 'catppuccin'
    end
  },

  { -- Tokyonight theme
    'folke/tokyonight.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      local tokyonight = require('tokyonight')
      tokyonight.setup({ style = 'storm' }) -- day, moon, night, storm
      tokyonight.load()
    end
  },

  { -- Rose Pine theme
    'rose-pine/neovim',
    enabled = false,
    lazy = false,
    priority = 1000,
    name = 'rose-pine',
    config = function()
      vim.cmd [[colorscheme rose-pine]]
    end
  },

  { -- Onedark theme inspired by Atom
    'navarasu/onedark.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme onedark]]
    end
  },
}
