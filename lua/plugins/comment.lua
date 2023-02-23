-- "gc" to comment visual regions/lines
local M = {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
  end
}

return M
