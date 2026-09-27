-- https://nvchad.com/docs/config/lsp
-- sets NvChad's capabilities/on_init for every server ("*"), LspAttach mappings and enables lua_ls
require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "ts_ls", -- "tsserver" was renamed to "ts_ls" in nvim-lspconfig
  "clangd",
  "jsonls",
  "dockerls",
  "docker_compose_language_service",
  "nginx_language_server",
  "tailwindcss",
  "harper_ls", -- grammar checker, replaces textlsp (doesn't build on python 3.14) and grammarly (deprecated)
  "jdtls",
  "yamlls",
  "rust_analyzer",
  "bashls",
  "pyright",
}

-- check prose only, not the comments of every programming language
vim.lsp.config("harper_ls", {
  filetypes = { "markdown", "text", "tex", "gitcommit" },
})

-- servers whose binary is not installed are skipped, run :MasonInstallAll to install them
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers, e.g.
-- vim.lsp.config("pyright", {
--   settings = { python = { analysis = { typeCheckingMode = "strict" } } },
-- })
