return {
  'nvim-lualine/lualine.nvim', -- Fancier statusline
  dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
  config = function() 
    -- Set lualine as statusline
    -- See `:help lualine.txt`
    require('lualine').setup {
      options = {
        theme = 'catppuccin',
      },
      sections = {
        lualine_c = {
          { 'filename', file_status = true, newfile_status = true, path = 1 },
        },
        lualine_x = {
          { 'filetype' },
        },
      },
    }
  end
}
