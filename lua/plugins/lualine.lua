-- Function fork from lunarvim
local lsp = function()
  local buf_clients = vim.lsp.get_active_clients()
  if next(buf_clients) == nil then
    return 'LS Inactive'
  end
  -- local buf_ft = vim.bo.filetype
  local buf_client_names = {}
  local copilot_active = false

  -- add client
  for _, client in pairs(buf_clients) do
    if client.name ~= 'null-ls' and client.name ~= 'copilot' then
      table.insert(buf_client_names, client.name)
    end

    if client.name == 'copilot' then
      copilot_active = true
    end
  end

  -- add formatter
  -- local formatters = require('null-ls.formatters') -- FIX: 'null-ls.formatters' is wrong
  -- local supported_formatters = formatters.list_registered(buf_ft)
  -- vim.list_extend(buf_client_names, supported_formatters)

  -- add linter
  -- local linters = require('null-ls.linters') -- FIX: 'null-ls.linters' is wrong
  -- local supported_linters = linters.list_registered(buf_ft)
  -- vim.list_extend(buf_client_names, supported_linters)

  local unique_client_names = vim.fn.uniq(buf_client_names)

  local language_servers = '[' .. table.concat(unique_client_names, ', ') .. ']'

  if copilot_active then
    language_servers = language_servers .. '%#SLCopilot#$*'
  end

  return language_servers
end

return {
  'nvim-lualine/lualine.nvim', -- Fancier statusline
  --event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
  config = function()
    -- Set lualine as statusline
    -- See `:help lualine.txt`
    require('lualine').setup {
      options = {
        theme = 'auto',
        disabled_filetypes = { 'neo-tree', 'nvimtree', 'alpha' },
      },
      sections = {
        lualine_c = {
          { 'filename', file_status = true, newfile_status = true, path = 1 },
        },
        lualine_x = {
          { lsp },
          -- { require('lazy.status').updates, cond = require('lazy.status').has_updates }, -- update plugins status
          { 'filetype' },
        },
      },
    }
  end
}
