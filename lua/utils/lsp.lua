local M = {}

M.lsp_signs = { Error = "✖ ", Warn = "! ", Hint = " ", Info = " " }

M.mason_packages = {
    "bash-language-server",
    "black",
    "clang-format",
    "clangd",
    "codelldb",
    "cspell",
    "css-lsp",
    "eslint-lsp",
    "graphql-language-service-cli",
    "html-lsp",
    "jdtls",
    "json-lsp",
    "lua-language-server",
    "markdownlint",
    "prettier",
    "pyright",
    "shfmt",
    "stylua",
    "tailwindcss-language-server",
    "taplo",
    "typescript-language-server",
    "yaml-language-server",
}

M.lsp_servers = {
    "clangd",
    "tsserver",
    "pyright",
    "sumneko_lua",
    "eslint",
    "bashls",
    "yamlls",
    "jsonls",
    "cssls",
    "taplo",
    "html",
    "graphql",
    "tailwindcss",
    "jdtls",
}

M.diagnostics_active = true

function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
    if values then
        if vim.opt_local[option]:get() == values[1] then
            vim.opt_local[option] = values[2]
        else
            vim.opt_local[option] = values[1]
        end
        return require("utils").info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
    end
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if not silent then
        if vim.opt_local[option]:get() then
            require("utils").info("Enabled " .. option, { title = "Option" })
        else
            require("utils").warn("Disabled " .. option, { title = "Option" })
        end
    end
end

function M.toggle_diagnostics()
    M.diagnostics_active = not M.diagnostics_active
    if M.diagnostics_active then
        vim.diagnostic.show()
        require("utils").info("Diagnostics Enabled", { title = "LSP" })
    else
        vim.diagnostic.hide()
        require("utils").warn("Diagnostics Disabled", { title = "LSP" })
    end
end

M.diagnostics = {
    off = {
        underline = false,
        virtual_text = false,
        signs = false,
        update_in_insert = false,
    },
    on = {
        underline = true,
        virtual_text = true,
        signs = { active = signs },
        update_in_insert = true,
        severity_sort = true,
        float = {
            focused = false,
            style = 'minimal',
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
        },
    },
}
vim.diagnostic.config(M.diagnostics[vim.g.diagnostics_enabled and 'on' or 'off'])

return M
