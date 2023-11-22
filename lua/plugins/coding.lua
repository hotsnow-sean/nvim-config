return {
    -- format
    {
        "sbdchd/neoformat",
        cmd = "Neoformat",
        init = function()
            vim.cmd([[
            augroup filetype_python
              autocmd!
              autocmd FileType python let b:neoformat_run_all_formatters = 1
            augroup END
            ]])

            vim.keymap.set({ "n" }, "<leader>fm", "<cmd>Neoformat<CR>", { desc = "format current buffer" })
        end,
        config = function()
            -- use these when filetype not found
            vim.g.neoformat_basic_format_align = 1
            vim.g.neoformat_basic_format_trim = 1
            vim.g.neoformat_basic_format_retab = 1
            vim.g.neoformat_only_msg_on_error = 1

            vim.g.neoformat_enabled_c = { "clangformat" }
            vim.g.neoformat_enabled_cpp = { "clangformat" }
            vim.g.neoformat_enabled_python = { "isort", "black" }
            vim.g.neoformat_enabled_lua = { "stylua" }
        end,
    },

    -- auto completions
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            {
                "L3MON4D3/LuaSnip",
                -- install jsregexp (optional!).
                build = "make install_jsregexp",
                dependencies = "rafamadriz/friendly-snippets",
                config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
            },
            "saadparwaiz1/cmp_luasnip",
            "windwp/nvim-autopairs",
            "onsails/lspkind.nvim",
        },
        opts = function()
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            local cmp = require("cmp")

            return {
                preselect = false,
                window = {
                    completion = {
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset = -3,
                        side_padding = 0,
                    },
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind =
                            require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        kind.kind = " " .. (strings[1] or "") .. " "
                        kind.menu = "    (" .. (strings[2] or "") .. ")"

                        return kind
                    end,
                },
                snippet = {
                    expand = function(args) require("luasnip").lsp_expand(args.body) end,
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                mapping = {
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- that way you will only jump inside the snippet region
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                    }),
                },
            }
        end,
        config = function(_, opts)
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")

            cmp.setup(opts)

            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
}
