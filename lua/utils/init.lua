local M = {}

local map = vim.keymap.set

M.git_colors = {
    GitAdd = "#A1C281",
    GitChange = "#74ADEA",
    GitDelete = "#FE747A",
}

M.treesitter_ensure_installed = {
  'bash',
  'c',
  'cpp',
  'css',
  'dockerfile',
  'go',
  'gomod',
  'gowork',
  'help',
  'html',
  'javascript',
  'json',
  'latex',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'regex',
  'rust',
  'scss',
  'sql',
  'todotxt',
  'toml',
  'typescript',
  'vim',
  'vue',
  'yaml',
}

function M.default_tbl(opts, default)
  opts = opts or {}
  return default and vim.tbl_deep_extend('force', default, opts) or opts
end

function M.notify(msg, type, opts)
  vim.schedule(function()
    vim.notify(msg, type, M.default_tbl(opts, { title = 'Nvim Notify' }))
  end)
end

-- Check if a plugin is installed
function M.is_available(plugin) return require('lazy.core.config').plugins[plugin] end

function M.warn(msg, notify_opts)
  vim.notify(msg, vim.log.levels.WARN, notify_opts)
end

function M.error(msg, notify_opts)
  vim.notify(msg, vim.log.levels.ERROR, notify_opts)
end

function M.info(msg, notify_opts)
  vim.notify(msg, vim.log.levels.INFO, notify_opts)
end

function M.default_tbl(opts, default)
  opts = opts or {}
  return default and vim.tbl_deep_extend('force', default, opts) or opts
end

function M.which_key_register(mappings, opts)
  local status_ok, which_key = pcall(require, 'which-key')
  if not status_ok then return end
  for mode, prefixes in pairs(mappings) do
    for prefix, mapping_table in pairs(prefixes) do
      which_key.register(
        mapping_table,
        M.default_tbl(opts, {
          mode = mode,
          prefix = prefix,
          buffer = nil,
          silent = true,
          noremap = true,
          nowait = true,
        })
      )
    end
  end
end

function M.set_mappings(map_table, base)
  for mode, maps in pairs(map_table) do
    for keymap, options in pairs(maps) do
      if options then
        local cmd = options
        local keymap_opts = base or {}
        if type(options) == 'table' then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend('force', options, keymap_opts)
          keymap_opts[1] = nil
        end
        map(mode, keymap, cmd, keymap_opts)
      end
    end
  end
end

M.user_terminals = {}
-- Toggle a user terminal if it exist, if not then create a new one and save it
function M.toggleterm_cmd(opts)
  local terms = M.user_terminals
  if type(opts) == 'string' then opts = { cmd = opts, hidden = true } end
  local num = vim.v.count > 0 and vim.v.count or 1
  if not terms[opts.cmd] then terms[opts.cmd] = {} end
  if not terms[opts.cmd][num] then
    if not opts.count then opts.count = vim.tbl_count(terms) * 100 + num end
    terms[opts.cmd][num] = require('toggleterm.terminal').Terminal:new(opts)
  end
  -- toggle the terminal
  M.user_terminals[opts.cmd][num]:toggle()
end


require('utils.lsp')
--require('utils.cmp')

return M
