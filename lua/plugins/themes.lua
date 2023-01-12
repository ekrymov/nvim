return {
  { -- Catppiccin theme
    'catppuccin/nvim',
    enabled = true,
    name = 'catppuccin',
    config = function()
      vim.cmd [[colorscheme catppuccin-mocha]]
    end
  },

  { -- Rose Pine theme
    'rose-pine/neovim',
    enabled = false,
    name = 'rose-pine',
    config = function()
      vim.cmd [[colorscheme rose-pine]]
    end
  },

  { -- Onedark theme inspired by Atom
    'navarasu/onedark.nvim',
    enabled = false,
    config = function()
      vim.cmd [[colorscheme onedark]]
    end
  },
}
