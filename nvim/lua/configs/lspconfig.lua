-- https://nvchad.com/docs/config/lsp
-- sets NvChad's capabilities/on_init for every server ("*"), LspAttach mappings and enables lua_ls
require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "ts_ls", -- "tsserver" was renamed to "ts_ls" in nvim-lspconfig
  "clangd",
  "jsonls",
  "dockerls", -- Dockerfile completion
  "docker_language_server", -- Docker's own server: compose files + Dockerfile hover/lint (buildx), replaces the archived compose-language-service
  "nginx_language_server",
  "tailwindcss",
  "harper_ls", -- grammar checker, replaces textlsp (doesn't build on python 3.14) and grammarly (deprecated)
  "jdtls",
  "yamlls",
  "rust_analyzer",
  "bashls",
  "pyright",
  -- go
  "gopls",
  "golangci_lint_ls", -- only in projects with a golangci-lint config, see below
  -- php / laravel
  "intelephense",
  "laravel_lsp", -- official Laravel LSP (composer global require laravel/lsp), only inside a Laravel app
}

-- check prose only, not the comments of every programming language
vim.lsp.config("harper_ls", {
  filetypes = { "markdown", "text", "tex", "gitcommit" },
})

vim.lsp.config("docker_language_server", {
  init_options = {
    telemetry = "off", -- on by default
    -- dockerls already reports these Dockerfile problems
    dockerfileExperimental = { removeOverlappingIssues = true },
  },
  settings = { docker = { lsp = { telemetry = "off" } } },
})

-- go
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-node_modules" },
      analyses = { nilness = true, unusedparams = true, unusedwrite = true, useany = true },
      codelenses = { generate = true, test = true, tidy = true, upgrade_dependency = true, vendor = true },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

-- golangci-lint only where the project uses it, gopls (staticcheck) covers the rest
vim.lsp.config("golangci_lint_ls", {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { ".golangci.yml", ".golangci.yaml", ".golangci.toml", ".golangci.json" })
    if root then
      on_dir(root)
    end
  end,
})

-- php: intelephense keeps its index in ~/intelephense by default
-- premium features need a licence: init_options = { licenceKey = "/path/to/licence.txt" }
vim.lsp.config("intelephense", {
  init_options = {
    storagePath = vim.fn.stdpath "cache" .. "/intelephense",
    globalStoragePath = vim.fn.stdpath "data" .. "/intelephense",
  },
})

-- html tags/attributes in blade templates
vim.lsp.config("html", {
  filetypes = { "html", "blade" },
  get_language_id = function(_, ft)
    return ft == "blade" and "html" or ft
  end,
})

-- servers whose binary is not installed are skipped, run :MasonInstallAll to install them
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers, e.g.
-- vim.lsp.config("pyright", {
--   settings = { python = { analysis = { typeCheckingMode = "strict" } } },
-- })
