return {
    -- color and themes
    {
        "navarasu/onedark.nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
        opts = {
            style = "warmer",
            highlights = require("config.cmp_color"),
        },
        config = function(_, opts)
            require("onedark").setup(opts)
            vim.cmd.colorscheme("onedark")
        end,
    },

    {
        "sainnhe/everforest",
        lazy = false,
        config = function()
            vim.g.everforest_diagnostic_line_highlight = 1
            vim.g.everforest_better_performance = 1
            vim.cmd.colorscheme("everforest")
        end,
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {
            options = {
                theme = "everforest",
            },
        },
    },

    -- bufferline
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "echasnovski/mini.bufremove",
        },
        init = function()
            vim.keymap.set({ "n" }, "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
            vim.keymap.set({ "n" }, "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
        end,
        opts = {
            options = {
                close_command = function(n) require("mini.bufremove").delete(n, false) end,
                diagnostics = "nvim_lsp",
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        text_align = "left",
                        separator = true,
                        highlight = "Directory",
                    },
                },
            },
        },
    },

    -- file explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        keys = {
            { "<F7>", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer", mode = { "v", "n", "i", "t" } },
        },
        init = function()
            vim.api.nvim_create_autocmd("BufEnter", {
                desc = "Open Neo-Tree on startup with directory",
                group = vim.api.nvim_create_augroup("neotree_start", { clear = true }),
                callback = function()
                    if package.loaded["neo-tree"] then
                        vim.api.nvim_del_augroup_by_name("neotree_start")
                    else
                        local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0)) -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
                        if stats and stats.type == "directory" then
                            vim.api.nvim_del_augroup_by_name("neotree_start")
                            require("neo-tree")
                        end
                    end
                end,
            })
        end,
        opts = {
            close_if_last_window = true,
            window = {
                width = 30,
            },
        },
    },
}
