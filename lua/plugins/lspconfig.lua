-- LSP settings.
-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
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
  gopls = {},             -- Go
  html = {},              -- HTML
  jsonls = {},            -- JSON
  --quick_lint_js = {},     -- JavaScript
  tsserver = {},          -- JavaScript, TypeScript
  ltex = {},              -- LaTeX
  --lexlab = {},            -- LaTeX
  sumneko_lua = {         -- Lua
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  --marksman = {},          -- Markdown
  --prosemd_lsp = {},       -- Markdown
  remark_ls = {},         -- Markdown
  --zk = {},                -- Markdown
  jedi_language_server = {}, -- Python
  --pyright = {},           -- Python
  --sourcery = {},          -- Python
  --pylsp = {},             -- Python
  --ruff_lsp = {},          -- Python
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
  
  { -- Linters & Formatters setup
    'jayp0521/mason-null-ls.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
      require('mason').setup()
      require('mason-null-ls').setup {
        ensure_installed = {
          'cpplint',
          'golangci_lint',
          'html_lint',
          'prettier',
          'fixjson',
          'luacheck',
          'vale',
          'flake8',
          'shellcheck',
          'taplo',
          'yamllint',
        },
        automatic_installation = false,
        automatic_setup = true,
      }
      require('null-ls').setup()
      require('mason-null-ls').setup_handlers()
    end
  },
}
