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

    -- pint in Laravel projects (their own vendor/bin/pint first), php-cs-fixer elsewhere
    php = { "pint", "php_cs_fixer", stop_after_first = true },
    blade = { "blade-formatter" },
  },

  formatters = {
    pint = {
      condition = function(_, ctx)
        return vim.fs.root(ctx.dirname, { "artisan", "pint.json" }) ~= nil
      end,
    },
    -- without a project config php-cs-fixer (3.9x) writes .php-cs-fixer.dist.php + .gitignore instead of formatting,
    -- so fall back to PSR-12 and no cache file
    php_cs_fixer = {
      args = function(_, ctx)
        if vim.fs.root(ctx.dirname, { ".php-cs-fixer.php", ".php-cs-fixer.dist.php" }) then
          return { "fix", "$FILENAME" }
        end
        return { "fix", "--rules=@PSR12", "--using-cache=no", "$FILENAME" }
      end,
    },
  },

  -- remove this table to only format with <leader>fm
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

return options
