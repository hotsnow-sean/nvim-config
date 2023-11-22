-- 行号
vim.opt.number = true
vim.opt.relativenumber = true
-- 边界偏移
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
-- 左侧标识列
vim.opt.signcolumn = "yes"
-- 缩进
vim.opt.expandtab = true
vim.opt.tabstop = 4
-- >>, << 时移动的长度
vim.opt.shiftwidth = 4
-- 折行标识符
vim.opt.showbreak = "↪"
-- 空白符标识符
vim.opt.listchars = "tab:▸ ,trail:⋅,extends:❯,precedes:❮"
vim.opt.list = true
-- 其他
vim.opt.switchbuf = "useopen"
vim.opt.mouse = "a"
vim.opt.clipboard:append({ "unnamedplus" })
-- 主题
vim.opt.termguicolors = true

-- 取消自动注释
local augroup = vim.api.nvim_create_augroup("disable_formatoptions_cro", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = augroup,
    command = "setlocal formatoptions-=cro",
})
