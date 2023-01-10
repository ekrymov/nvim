return {
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup {
      disable_in_macro = true,
      check_ts = true,
    }
  end
}
