
-- Indentation guides even on blank lines
-- lukas-reineke/indent-blankline.nvim
-- See `:help indent_blankline.txt`
return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufReadPre',
  config = function()
    vim.o.termguicolors = true
    vim.cmd [[highlight CurrentContext guifg=#6E6E6E gui=nocombine]]
    require('indent_blankline').setup {
      enabled = true,                                -- on/off plugin
      filetype = {},                                 -- включать подсветку для указанных типов файлов
      filetype_exclude = {                           -- выключить подсветку для указанных типов файлов
        'alpha',
        'help',
        'neo-tree',
      },
      show_current_context = true,                   -- подсвечивать текущий контекст
      context_highlight_list = { 'CurrentContext' },
      char = '┊',
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      use_treesitter_scope = true,
    }
  end
}
