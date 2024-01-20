return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "andymass/vim-matchup",
            "windwp/nvim-ts-autotag",
        },
        opts = {
            ensure_installed = {
                "lua",
                "bash",
                "vim",
                "vimdoc",
                "c",
                "cpp",
                "cmake",
                "python",
                "markdown",

                "rust",
                "go",

                "html",
                "css",
                "javascript",
                "typescript",
                "json",
                "yaml",
            },
            sync_install = true,
            highlight = { enable = true },
            indent = { enable = true },

            textobjects = {
                select = {
                    enable = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]p"] = "@parameter.inner",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[p"] = "@parameter.inner",
                    },
                },
            },

            matchup = {
                enable = true,
            },

            autotag = {
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            vim.g.matchup_matchparen_offscreen = { method = "popup" }

            -- fold
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            -- vim.opt.foldenable = false
            vim.opt.foldlevelstart = 99
        end,
    },
}
