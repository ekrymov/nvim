ui = {}

local function bool2str(bool) return bool and 'on' or 'off' end

local function ui_notify(str)
  if vim.g.ui_notifications_enabled then
    require('utils').notify(str)
  end
end

-- Toggle autoformat
function ui.toggle_autoformat()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  ui_notify(string.format('Autoformatting %s', bool2str(vim.g.autoformat_enabled)))
end

-- Toggle autopairs
function ui.toggle_autopairs()
  local ok, autopairs = pcall(require, 'nvim-autopairs')
  if ok then
    if autopairs.state.disabled then
      autopairs.enable()
    else
      autopairs.disable()
    end
    vim.g.autopairs_enabled = autopairs.state.disabled
    ui_notify(string.format('Autopairs %s', bool2str(not autopairs.state.disabled)))
  else
    ui_notify('Autopairs not available')
  end
end

-- Toggle autocompletion
function ui.toggle_cmp()
  vim.g.cmp_enabled = not vim.g.cmp_enabled
  local ok, _ = pcall(require, 'cmp')
  ui_notify(ok and string.format('Completion %s', bool2str(vim.g.cmp_enabled)) or 'Completion not available')
end

-- Toggle diagnostics
function ui.toggle_diagnostics()
  local status = 'on'
  if vim.g.status_diagnostics_enabled then
    if vim.g.diagnostics_enabled then
      vim.g.diagnostics_enabled = false
      status = 'virtual text off'
    else
      vim.g.status_diagnostics_enabled = false
      status = 'fully off'
    end
  else
    vim.g.diagnostics_enabled = true
    vim.g.status_diagnostics_enabled = true
  end

  vim.diagnostic.config() -- FIX: добавить параметры
  ui_notify(string.format('diagnostics %s', status))
end

return ui