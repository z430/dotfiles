-- turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable concealing in some file formats
-- The default concealing level is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- auto format when saving python file
vim.api.nvim_create_augroup("AutoFormat", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.py",
  group = "AutoFormat",
  callback = function()
    vim.cmd("silent !black --config pyproject.toml --quiet %")
    vim.cmd("silent !ruff check --config pyproject.toml --fix --quiet %")
    vim.cmd("edit")
  end,
})
