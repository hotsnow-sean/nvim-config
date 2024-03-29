return {
    -- notify
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        cond = function() return not vim.g.vscode end,
        init = function()
            if vim.g.vscode then
                vim.notify = vscode.notify
            end
        end,
        config = function() vim.notify = require("notify") end,
    },

    -- auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },

    -- comment
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                dependencies = "nvim-treesitter/nvim-treesitter",
            },
        },
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
                end,
            },
        },
    },

    -- blankline
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPre", "BufNewFile" },
        main = "ibl",
        opts = {},
    },

    -- match up
    {
        "andymass/vim-matchup",
        init = function()
            vim.g.matchup_matchparen_offscreen = {
                method = "popup",
            }
        end,
    },

    -- terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        init = function()
            function _G.set_terminal_keymaps()
                local opts = { buffer = 0 }
                vim.keymap.set("n", "<esc>", [[<Cmd>quit<CR>]], opts)
                vim.keymap.set("n", "q", [[<Cmd>quit<CR>]], opts)
                vim.keymap.set("n", "<C-c>", [[<Cmd>startinsert<CR><C-c>]], opts)
                vim.keymap.set("n", "<CR>", [[<Cmd>startinsert<CR>]], opts)
                vim.keymap.set("n", "<Up>", [[<Cmd>startinsert<CR><Up>]], opts)
                vim.keymap.set("n", "<Down>", [[<Cmd>startinsert<CR><Down>]], opts)
                vim.keymap.set("n", "<Right>", [[<Cmd>startinsert<CR><Right>]], opts)
                vim.keymap.set("n", "<Left>", [[<Cmd>startinsert<CR><Left>]], opts)
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
                vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
            end

            -- if you only want these mappings for toggle term use term://*toggleterm#* instead
            vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
        end,
        opts = {
            open_mapping = [[<F8>]],
            float_opts = {
                border = "curved",
                winblend = 3,
            },
        },
        config = function(_, opts)
            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                float_opts = {
                    border = "rounded",
                },
                on_open = function(term)
                    vim.api.nvim_buf_set_keymap(
                        term.bufnr,
                        "n",
                        "q",
                        "<cmd>close<CR>",
                        { noremap = true, silent = true }
                    )
                end,
                on_close = function(_)
                    local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
                    if manager_avail then
                        for _, source in ipairs({ "filesystem", "git_status", "document_symbols" }) do
                            local module = "neo-tree.sources." .. source
                            if package.loaded[module] then
                                manager.refresh(require(module).name)
                            end
                        end
                    end
                end,
            })
            ---@diagnostic disable-next-line: lowercase-global
            function _lazygit_toggle() lazygit:toggle() end
            vim.api.nvim_set_keymap(
                "n",
                "<leader>gg",
                "<cmd>lua _lazygit_toggle()<CR>",
                { noremap = true, silent = true }
            )

            require("toggleterm").setup(opts)
        end,
    },

    -- git signs
    {
        "lewis6991/gitsigns.nvim",
        ft = { "gitcommit", "diff" },
        init = function()
            -- load gitsigns only when a git file is opened
            vim.api.nvim_create_autocmd({ "BufRead" }, {
                group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
                callback = function()
                    vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
                    if vim.v.shell_error == 0 then
                        vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
                        vim.schedule(function() require("lazy").load({ plugins = { "gitsigns.nvim" } }) end)
                    end
                end,
            })
        end,
        config = function(_, opts)
            require("gitsigns").setup(opts)

            vim.keymap.set({ "n", "x", "o" }, "]h", "<cmd>Gitsigns next_hunk<CR>")
            vim.keymap.set({ "n", "x", "o" }, "[h", "<cmd>Gitsigns prev_hunk<CR>")
        end,
    },

    "mg979/vim-visual-multi",
}
