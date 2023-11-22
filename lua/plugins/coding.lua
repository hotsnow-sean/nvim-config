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
}
