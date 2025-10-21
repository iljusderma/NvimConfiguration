-- Error message, solution:
-- https://github.com/LazyVim/LazyVim/issues/6039
return {
  {
    "mason-org/mason.nvim",
    -- version = "^1.0.0",
    enabled = true,
  },
  { "mason-org/mason-lspconfig.nvim", enabled = false, version = "^1.0.0" },
}
