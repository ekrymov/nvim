function alpha_button(sc, txt)
  -- replace <leader> in shortcut text with LDR for nicer printing
  local sc_ = sc:gsub('%s', ''):gsub('LDR', '<leader>')
  -- if the leader is set, replace the text with the actual leader key for nicer printing
  if vim.g.mapleader then sc = sc:gsub('LDR', vim.g.mapleader == ' ' and 'SPC' or vim.g.mapleader) end
  -- return the button entity to display the correct text and send the correct keybinding on press
  return {
    type = 'button',
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
      vim.api.nvim_feedkeys(key, 'normal', false)
    end,
    opts = {
      position = 'center',
      text = txt,
      shortcut = sc,
      cursor = 5,
      width = 36,
      align_shortcut = 'right',
      hl = 'DashboardCenter',
      hl_shortcut = 'DashboardShortcut',
    },
  }
end

return {
  'goolord/alpha-nvim',
  enabled = true,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local dashboard = require('alpha.themes.dashboard')
    dashboard.section.buttons.val = {
      --dashboard.button( "e", "  New file" , ":ene <BAR> startinsert <CR>"),
      --dashboard.button( "q", "  Quit NVIM" , ":qa<CR>"),

      alpha_button("LDR f f", "  Find File  "),
      alpha_button("LDR f o", "  Recents  "),
      alpha_button("LDR f w", "  Find Word  "),
      alpha_button("LDR f n", "  New File  "),
      alpha_button("LDR f m", "  Bookmarks  "),
      alpha_button("LDR S l", "  Last Session  "),
    }
    
    local startify = require('alpha.themes.startify')
    startify.section.top_buttons.val = {}
    startify.section.bottom_buttons.val = {
      startify.button( "q", "  Quit NVIM" , "<cmd>qa<cr>"),
    }

    require('alpha').setup(startify.config) -- startify.config or dashboard.config
  end
}
