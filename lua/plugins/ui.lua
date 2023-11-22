return {
    -- color and themes
    {
        "navarasu/onedark.nvim",
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
                -- create a new, empty buffer
                vim.cmd.enew()
                -- wipe the directory buffer
                vim.cmd.bw(data.buf)
                -- change to the directory
                vim.cmd.cd(data.file)
                -- open the tree
                require("nvim-tree.api").tree.open()
            end

            vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

            vim.api.nvim_create_autocmd("QuitPre", {
                callback = function()
                    local invalid_win = {}
                    local wins = vim.api.nvim_list_wins()
                    for _, w in ipairs(wins) do
                        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                        if bufname:match("NvimTree_") ~= nil then
                            table.insert(invalid_win, w)
                        end
                    end
                    if #invalid_win == #wins - 1 then
                        -- Should quit, so we close all invalid windows.
                        for _, w in ipairs(invalid_win) do
                            vim.api.nvim_win_close(w, true)
                        end
                    end
                end,
            })
        end,
        config = function(_, opts)
            local api = require("nvim-tree.api")
            api.events.subscribe(api.events.Event.FileCreated, function(file) vim.cmd("edit " .. file.fname) end)

            require("nvim-tree").setup(opts)
        end,
    },

    -- improve ui
    {
        "stevearc/dressing.nvim",
        opts = {},
    },
}
