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
-- vim.lsp.enable("julials")

require("lspconfig").julials.setup({
  on_new_config = function(new_config, new_root_dir)
    local server_path = "/home/ilja/.julia/packages/LanguageServer/Fwm1f/src"
    local cmd = {
      "julia",
      "--project=" .. server_path,
      "--startup-file=no",
      "--history-file=no",
      "-e",
      [[
          using Pkg
          Pkg.instantiate()
          using LanguageServer
          depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
          project_path = let
              dirname(something(
                  ## 1. Finds an explicitly set project (JULIA_PROJECT)
                  Base.load_path_expand((
                      p = get(ENV, "JULIA_PROJECT", nothing);
                      p === nothing ? nothing : isempty(p) ? nothing : p
                  )),
                  ## 2. Look for a Project.toml file in the current working directory,
                  ##    or parent directories, with $HOME as an upper boundary
                  Base.current_project(),
                  ## 3. First entry in the load path
                  get(Base.load_path(), 1, nothing),
                  ## 4. Fallback to default global environment,
                  ##    this is more or less unreachable
                  Base.load_path_expand("@v#.#"),
              ))
          end
          @info "Running language server" VERSION pwd() project_path depot_path
          server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
          server.runlinter = true
          run(server)
        ]],
    }
    new_config.cmd = cmd
  end,
  settings = {
    julia = {
      lint = {
        missingrefs = "none",
      },
    },
  },
})
