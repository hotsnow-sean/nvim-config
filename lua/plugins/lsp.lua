return {
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonUpdate" },
        opts = {},
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
            ensure_installed = { "lua_ls", "bashls", "vimls", "clangd", "cmake", "pyright", "rust_analyzer", "gopls" },
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
        "kkharji/lspsaga.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = "neovim/nvim-lspconfig",
        cmd = "Lspsaga",
        init = function()
            vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<CR>")
            vim.keymap.set("n", "<leader>la", "<cmd>Lspsaga code_action<CR>")
            vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
            vim.keymap.set("n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>")
            vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
            vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
        end,
        opts = {
            error_sign = "󰅚",
            warn_sign = "󰀪",
            hint_sign = "󰌶",
            infor_sign = "",
            code_action_icon = "󰌵 ",
            code_action_keys = {
                quit = "q",
                exec = "<CR>",
            },
            rename_action_keys = {
                quit = "<Esc>",
                exec = "<CR>",
            },
            border_style = "round",
            rename_prompt_prefix = "▶",
        },
    },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },
}
