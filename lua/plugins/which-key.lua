local M = {
  'folke/which-key.nvim',
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require('which-key').setup {
      plugins = {
        spelling = { enabled = true },
        presets = { operators = false },
      },
      window = {
        border = 'rounded',
        padding = { 2, 2, 2, 2 },
      },
      disable = {
        filetypes = { 'TelescopePrompt' },
      },
    }
  end,
  --which_key_register(mappings),
}

return M
