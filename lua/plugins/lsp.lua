return {
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonUpdate" },
        opts = {},
    },

    {
        "neovim/nvim-lspconfig",
        init = function()
            vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end)
            vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end)
            vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end)
        end,
        config = function()
            local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        cmd = { "LspInstall", "LspUninstall" },
        opts = {
            ensure_installed = { "lua_ls", "bashls", "vimls" },
            automatic_installation = true,
        },
        config = function(_, opts)
            require("mason").setup()
            require("mason-lspconfig").setup(opts)

            require("mason-lspconfig").setup_handlers({
                -- The first entry (without a key) will be the default handler
                -- and will be called for each installed server that doesn't have
                -- a dedicated handler.
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup({})
                end,
                -- Next, you can provide a dedicated handler for specific servers.
                -- For example, a handler override for the `rust_analyzer`:
                -- ["rust_analyzer"] = function() require("rust-tools").setup({}) end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        on_init = function(client)
                            local path = client.workspace_folders[1].name
                            if
                                not vim.loop.fs_stat(path .. "/.luarc.json")
                                and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
                            then
                                client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
                                    Lua = {
                                        runtime = {
                                            -- Tell the language server which version of Lua you're using
                                            -- (most likely LuaJIT in the case of Neovim)
                                            version = "LuaJIT",
                                        },
                                        -- Make the server aware of Neovim runtime files
                                        workspace = {
                                            checkThirdParty = false,
                                            library = {
                                                vim.env.VIMRUNTIME,
                                                -- "${3rd}/luv/library"
                                                -- "${3rd}/busted/library",
                                            },
                                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                            -- library = vim.api.nvim_get_runtime_file("", true)
                                        },
                                    },
                                })

                                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                            end
                            return true
                        end,
                    })
                end,
            })
        end,
    },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },
}
