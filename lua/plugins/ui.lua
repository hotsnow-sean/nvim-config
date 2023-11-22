return {
    -- color and themes
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function() vim.cmd.colorscheme("catppuccin") end,
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = true,
    },

    -- bufferline
    {
        "akinsho/bufferline.nvim",
        event = "BufReadPre",
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
                        filetype = "NvimTree",
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
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        keys = {
            { "<F7>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer", mode = { "v", "n", "i", "t" } },
        },
        init = function()
            local function open_nvim_tree(data)
                -- buffer is a directory
                local directory = vim.fn.isdirectory(data.file) == 1
                if not directory then
                    return
                end
                -- change to the directory
                vim.cmd.cd(data.file)
                -- open the tree
                require("nvim-tree.api").tree.open()
            end

            vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
        end,
        config = function(_, opts)
            local api = require("nvim-tree.api")
            api.events.subscribe(api.events.Event.FileCreated, function(file) vim.cmd("edit " .. file.fname) end)
            require("nvim-tree").setup(opts)
        end,
    },
}
