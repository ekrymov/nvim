-- LSP settings.
-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --

  local tbl_contains = vim.tbl_contains
  local tbl_isempty = vim.tbl_isempty
  local capabilities = client.server_capabilities
  local is_available = require('utils').is_available
  local default_tbl = require('utils').default_tbl

  local formatting = { -- TODO: move to config
    format_on_save = {
      enabled = true,
      allow_filetypes = {},
      ignore_filetypes = {},
    },
    disabled = {},
    timeout_ms = 1000,
  }

  local format_opts = vim.deepcopy(formatting)
  format_opts.disabled = nil
  format_opts.format_on_save = true
  format_opts.filter = function(client)
    local filter = formatting.filter
    local disabled = formatting.disabled or {}
    return not (vim.tbl_contains(disabled, client.name) or (type(filter) == 'function' and not filter(client)))
  end
  
  local lsp_mappings = {
    n = {
      ['<leader>ld'] = { function() vim.diagnostic.open_float() end, desc = 'Hover diagnostics' },
      ['[d'] = { function() vim.diagnostic.goto_prev() end, desc = 'Previous diagnostic' },
      [']d'] = { function() vim.diagnostic.goto_next() end, desc = 'Next diagnostic' },
      ['gl'] = { function() vim.diagnostic.open_float() end, desc = 'Hover diagnostics' },
    },
    v = {},
  }

  if is_available('mason-lspconfig.nvim') then
    lsp_mappings.n['<leader>li'] = { '<cmd>LspInfo<cr>', desc = 'LSP information' }
  end
  
  if is_available('null-ls.nvim') then
    lsp_mappings.n['<leader>lI'] = { '<cmd>NullLsInfo<cr>', desc = 'Null-ls information' }
  end

  if capabilities.codeActionProvider then
    lsp_mappings.n['<leader>la'] = { function() vim.lsp.buf.code_action() end, desc = 'LSP code action' }
    lsp_mappings.v['<leader>la'] = lsp_mappings.n['<leader>la']
  end

  if capabilities.codeLensProvider then
    lsp_mappings.n['<leader>ll'] = { function() vim.lsp.codelens.refresh() end, desc = 'LSP codelens refresh' }
    lsp_mappings.n['<leader>lL'] = { function() vim.lsp.codelens.run() end, desc = 'LSP codelens run' }
  end

  if capabilities.declarationProvider then
    lsp_mappings.n['gD'] = { function() vim.lsp.buf.declaration() end, desc = 'Declaration of current symbol' }
  end

  if capabilities.definitionProvider then
    lsp_mappings.n['gd'] = {
      function() vim.lsp.buf.definition() end, desc = 'Show the definition of current symbol'
    }
  end

  if capabilities.documentFormattingProvider and not tbl_contains(formatting.disabled, client.name) then
    lsp_mappings.n['<leader>lf'] = { function() vim.lsp.buf.format(format_opts) end, desc = 'Format buffer' }
    lsp_mappings.v['<leader>lf'] = lsp_mappings.n['<leader>lf']

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(
      bufnr,
      'Format',
      function() vim.lsp.buf.format(format_opts) end,
      { desc = 'Format file with LSP' }
    )
    local autoformat = formatting.format_on_save
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    if
      autoformat.enabled
      and (tbl_isempty(autoformat.allow_filetypes or {}) or tbl_contains(autoformat.allow_filetypes, filetype))
      and (tbl_isempty(autoformat.ignore_filetypes or {}) or tbl_contains(autoformat.ignore_filetypes, filetype))
    then
      local autocmd_group = 'auto_format_' .. bufnr
      vim.api.nvim_create_augroup(autocmd_group, { clear = true })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = autocmd_group,
        buffer = bufnr,
        desc = 'Auto format buffer ' .. bufnr .. ' before save',
        callback = function()
          if vim.g.autoformat_enabled then
            vim.lsp.buf.format(default_tbl({ bufnr = bufnr }, format_opts))
          end
        end,
      })
      lsp_mappings.n['<leader>uf'] = {
        function() require('utils.ui').toggle_autoformat() end,
        desc = 'Toggle autoformatting',
      }
    end
  end

  if capabilities.documentHighlightProvider and false then -- INFO: отключено, т.к. использую аддот nvim-illuminate
    local highlight_name = vim.fn.printf('lsp_document_highlight_%d', bufnr)
    vim.api.nvim_create_augroup(highlight_name, { clear = true })
    vim.api.nvim_clear_autocmds { group = highlight_name, buffer = bufnr }
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = highlight_name,
      buffer = bufnr,
      callback = function() vim.lsp.buf.document_highlight() end,
      desc = 'Document Highlight',
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = highlight_name,
      buffer = bufnr,
      callback = function() vim.lsp.buf.clear_references() end,
      desc = 'Clear All the References',
    })
  end

  if capabilities.hoverProvider then
    lsp_mappings.n['K'] = { function() vim.lsp.buf.hover() end, desc = 'Hover symbol details' }
  end

  if capabilities.implementationProvider then
    lsp_mappings.n['gI'] = {
      function() vim.lsp.buf.implementation() end, desc = 'Implementation of current symbol',
    }
  end

  if capabilities.referencesProvider then
    lsp_mappings.n['gr'] = { function() vim.lsp.buf.references() end, desc = 'References of current symbol' }
    lsp_mappings.n['<leader>lR'] = { function() vim.lsp.buf.references() end, desc = 'Search references' }
  end

  if capabilities.renameProvider then
    lsp_mappings.n['<leader>lr'] = {
      function() vim.lsp.buf.rename() end, desc = 'Rename current symbol',
    }
  end

  if capabilities.signatureHelpProvider then
    lsp_mappings.n['<leader>lh'] = { function() vim.lsp.buf.signature_help() end, desc = 'Signature help' }
  end

  if capabilities.typeDefinitionProvider then
    lsp_mappings.n['gT'] = {
      function() vim.lsp.buf.type_definition() end, desc = 'Definition of current type',
    }
  end

  if capabilities.workspaceSymbolProvider then
    lsp_mappings.n['<leader>lG'] = {
      function() vim.lsp.buf.workspace_symbol() end, desc = 'Search workspace symbols',
    }
  end

  if capabilities.documentSymbolProvider then
    lsp_mappings.n['<leader>ls'] = {
      function() vim.lsp.buf.document_symbol() end, desc = 'Document symbols',
    }
  end

  if is_available('telescope.nvim') then
    local tb = require('telescope.builtin')
    if lsp_mappings.n.gd then lsp_mappings.n.gd[1] = function() tb.lsp_definitions() end end
    if lsp_mappings.n.gI then lsp_mappings.n.gI[1] = function() tb.lsp_implementations() end end
    if lsp_mappings.n.gr then lsp_mappings.n.gr[1] = function() tb.lsp_references() end end
    if lsp_mappings.n['<leader>lR'] then
      lsp_mappings.n['<leader>lR'][1] = function() tb.lsp_references() end
    end
    if lsp_mappings.n.gT then lsp_mappings.n.gT[1] = function() tb.lsp_type_definitions() end end
    if lsp_mappings.n['<leader>lG'] then
      lsp_mappings.n['<leader>lG'][1] = function() tb.lsp_workspace_symbols() end
    end
    if lsp_mappings.n['<leader>ls'] then
      lsp_mappings.n['<leader>ls'][1] = function()
        local aerial_avail, _ = pcall(require, 'aerial')
        if aerial_avail then
          require('telescope').extensions.aerial.aerial()
        else
          tb.lsp_document_symbols()
        end
      end
    end
    if lsp_mappings.n['<leader>lG'] then
      lsp_mappings.n['<leader>lG'][1] = function() tb.lsp_dynamic_workspace_symbols() end
    end
    lsp_mappings.n['<leader>lD'] = { function() tb.diagnostics() end, desc = 'Search diagnostics' }
  end
  
  -- Lesser used LSP functionality
  lsp_mappings.n['<leader>lW'] = {
    function() vim.lsp.buf.add_workspace_folder() end,
    desc = 'Add workspace folder',
  }
  lsp_mappings.n['<leader>lR'] = {
    function() vim.lsp.buf.remove_workspace_folder() end,
    desc =  'Remove workspace folder',
  }
  lsp_mappings.n['<leader>lw'] = {
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    desc = 'List workspace folders',
  }
  
  require('utils').set_mappings(lsp_mappings, { buffer = bufnr })
  if not vim.tbl_isempty(lsp_mappings.v) then
    require('utils').which_key_register({ v = { ['<leader>'] = { l = { name = 'LSP' } } } }, { buffer = bufnr })
  end
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  --asm_lsp = {},           -- Assembly (GAS/NASM, GO)
  bashls = {},            -- Bash
  clangd = {},            -- C, C++
  cssls = {},             -- CSS
  --cssmodules_ls = {},     -- CSS
  dockerls = {},          -- Docker
  --golangci_lint_ls = {},  -- Go
  gopls = {               -- Go
    gopls = {
      gofumpt = true,
    },
  },
  html = {},              -- HTML
  jsonls = {},            -- JSON
  --quick_lint_js = {},     -- JavaScript
  tsserver = {},          -- JavaScript, TypeScript
  ltex = {},              -- LaTeX
  --lexlab = {},            -- LaTeX
  lua_ls = {              -- Lua
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = { checkThirdParty = false },
    },
  },
  marksman = {},          -- Markdown
  --prosemd_lsp = {},       -- Markdown
  --remark_ls = {},         -- Markdown
  --zk = {},                -- Markdown
  --jedi_language_server = {}, -- Python
  --pyright = {},           -- Python
  --sourcery = {},          -- Python
  pylsp = {               -- Python
    pylsp = {
      plugins = {
        pyflakes = {
          enabled = false,
        },
        flake8 = {
          enabled = true,
          maxLineLength = 120,
        },
        pycodestyle = {
          --enabled = false,
          ignore = { 'W291' },
          maxLineLength = 120,
        },
        pylint = {
          enabled = false,
          args = {},
        },
      },
    },
  },
  --ruff_lsp = {},            -- Python
  rust_analyzer = {},     -- Rust
  sqlls = {},             -- SQL
  --sqls = {},              -- SQL
  taplo = {},             -- TOML
  volar = {},             -- Vue
  --vuels = {},             -- Vue
  yamlls = {},            -- YAML
}

return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',

      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      require('fidget').setup()
      require('neodev').setup()
      
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      capabilities.offsetEncoding = 'utf-8'
      
      -- Setup mason so it can manage external tooling
      require('mason').setup()

      -- Ensure the servers above are installed
      local mason_lspconfig = require('mason-lspconfig')

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }
      
      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
          }
        end,
      }
    end
  },

  -- Linters & Formatters setup
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local null_ls = require('null-ls')
      local f = null_ls.builtins.formatting
      local d = null_ls.builtins.diagnostics
      local a = null_ls.builtins.code_actions
      local c = null_ls.builtins.completion
      null_ls.setup {
        debug = true,
        sources = {
          -- completion
          c.luasnip,
          -- formatters
          --f.autopep8,
          f.beautysh,
          --f.black,
          f.clang_format,
          --f.eslint_d,
          f.gofumpt,
          f.prettier,
          f.rustfmt,
          f.stylua,
          f.taplo,
          f.yamlfmt,
          -- diagnostics
          --d.clang_check,
          --d.cppcheck,
          d.cpplint,
          --d.dotenv_linter,
          d.eslint_d,
          --d.flake8,
          d.golangci_lint,
          d.jsonlint,
          --d.luacheck,
          --d.pylama,
          d.pylint.with {
            diagnostic_config = { underline = false, virtual_text = false, signs = false },
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          },
          --d.ruff.with { extra_args = { '--line-length=120' } },
          d.selene,
          d.shellcheck.with { extra_args = { 'disable', 'SC2086' } },
          --d.todo_comments,
          d.vale,
          d.yamllint,
          -- code actions
          a.gitsigns,
        },
      }
    end
  },
  {
    'jayp0521/mason-null-ls.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
      require('mason').setup()
      require('mason-null-ls').setup {
        ensure_installed = nil,
        automatic_installation = true,
        automatic_setup = false,
      }
    end
  },
}
