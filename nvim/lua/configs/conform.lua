-- formatters that used to run through null-ls (jose-elias-alvarez/null-ls.nvim is gone)
local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    -- webdev stuff: deno for js/ts files cuz its very fast, prettier for the rest
    javascript = { "deno_fmt" },
    javascriptreact = { "deno_fmt" },
    typescript = { "deno_fmt" },
    typescriptreact = { "deno_fmt" },
    json = { "deno_fmt" },
    jsonc = { "deno_fmt" },
    html = { "prettier" },
    css = { "prettier" },
    markdown = { "prettier" },

    c = { "clang-format" },
    cpp = { "clang-format" },

    rust = { "rustfmt" }, -- comes with rustup, mason no longer ships it

    python = { "black" },

    go = { "goimports", "gofumpt" },
  },

  -- remove this table to only format with <leader>fm
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

return options
