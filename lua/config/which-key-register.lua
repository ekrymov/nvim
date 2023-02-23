local register = require('utils').which_key_register
local is_available = require('utils').is_available

local mappings = {
  n = {
    ['<leader>'] = {
      f = { name = 'File' },
      p = { name = 'Packages' },
      l = { name = 'LSP' },
      u = { name = 'UI' },
    },
  },
}

local extra_sections = {
  b = 'Buffers',
  D = 'Debugger',
  g = 'Git',
  s = 'Search',
  S = 'Session',
  t = 'Terminal',
}

local function init_table(mode, prefix, idx)
  if not mappings[mode][prefix][idx] then
    mappings[mode][prefix][idx] = { name = extra_sections[idx] }
  end
end

-- gitsigns.nvim
if is_available('gitsigns.nvim') then
  init_table('n', '<leader>', 'g')
end

-- telescope.nvim
if is_available('telescope.nvim') then
  init_table('n', '<leader>', 's')
  init_table('n', '<leader>', 'g')
end

-- Comment.nvim
if is_available('Comment.nvim') then
  for _, mode in ipairs { 'n', 'v' } do
    if not mappings[mode] then mappings[mode] = {} end
    if not mappings[mode].g then mappings[mode].g = {} end
    mappings[mode].g.c = 'Comment toggle linewise'
    mappings[mode].g.b = 'Comment toggle blockwise'
  end
end

-- neovim-session manager
if is_available('neovim-session-manager') then
  init_table('n', '<leader>', 'S')
end

-- toggleterm.nvim
if is_available('toggleterm.nvim') then
  init_table('n', '<leader>', 't')
end

init_table('n', '<leader>', 'b')

register(mappings)