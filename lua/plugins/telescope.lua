return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    cmd = "Telescope",
    init = function()
        -- file
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "find files" })
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "find buffers" })
        -- word
        vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "find word in project" })
        vim.keymap.set(
            "n",
            "<leader><leader>",
            "<cmd>Telescope current_buffer_fuzzy_find<CR>",
            { desc = "fuzzy find word in current" }
        )
        -- lsp
        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "goto the definition" })
        vim.keymap.set(
            "n",
            "gsd",
            "<cmd>Telescope lsp_type_definitions<CR>",
            { desc = "goto the definition of the type" }
        )
        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "goto the implementation" })
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "list references" })
        vim.keymap.set(
            "n",
            "<leader>d",
            "<cmd>Telescope diagnostics<CR>",
            { desc = "list all diagnostics (open buffers)" }
        )
        -- treesitter
        vim.keymap.set("n", "<leader>z", "<cmd>Telescope treesitter<CR>", { desc = "lists function names, variables" })
        -- git
        vim.keymap.set("n", "<leader>c", "<cmd>Telescope git_commits<CR>", { desc = "list git commits" })
        vim.keymap.set("n", "<leader>C", "<cmd>Telescope git_branches<CR>", { desc = "list git branches" })
        -- other
        vim.keymap.set("n", "<leader>q", "<cmd>Telescope quickfix<CR>", { desc = "list quickfix" })
        vim.keymap.set("n", "<leader>t", "<cmd>TodoTelescope<CR>", { desc = "list todo" })
    end,
    config = function(_, opts)
        require("telescope").setup(opts)

        require("telescope").load_extension("fzf")
    end,
}
