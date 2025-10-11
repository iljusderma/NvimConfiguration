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
-- use julia LanguageServer
require("lspconfig").julials.setup({
  cmd = {
    "julia",
    "--startup-file=no",
    "--history-file=no",
    "-i",
    "--project=@.",
    "-e",
    "using LanguageServer; LanguageServer.Server()",
  },
  filetypes = { "julia" },
  root_dir = require("lspconfig").util.root_pattern("Project.toml", ".git"),
})
-- create permanent shortcut to exit Terminal
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
