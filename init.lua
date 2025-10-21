-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- set tabsize to 4
vim.o.shiftwidth = 4
-- disable spellcheck in markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})
-- use julia language server
vim.lsp.enable("julials")
