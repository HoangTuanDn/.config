-- overrides of the plugins that NvChad already ships (lua/nvchad/plugins/init.lua)
return {
  -- completion: blink.cmp instead of nvim-cmp (NvChad's own blink setup, disables nvim-cmp)
  -- nvim-cmp's docs window calls vim.lsp.util.stylize_markdown, deprecated in nvim 0.13 and removed in 0.14
  { import = "nvchad.blink.lazyspec" },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- format on save
    cmd = "ConformInfo",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- :MasonInstallAll only sees the servers passed to vim.lsp.enable once nvim-lspconfig is loaded,
  -- without this it skips every lsp server when run before a file is opened (e.g. from nvdash)
  {
    "mason-org/mason.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    -- replaces NvChad's ":TSUpdate | TSInstallAll": those commands don't exist yet when lazy installs on startup.
    -- parsers are built by tree-sitter-cli (installed by :MasonInstallAll), without it every parser errors out,
    -- so on the very first start run :MasonInstallAll, then :TSInstallAll
    build = function(plugin)
      if vim.fn.executable "tree-sitter" == 1 then
        local ts = require "nvim-treesitter"
        ts.update():await(function()
          ts.install(plugin.opts.ensure_installed)
        end)
      end
    end,
    -- must stay a table: :TSInstallAll reads this list (NvChad's defaults are included)
    opts = {
      ensure_installed = {
        "lua",
        "luadoc",
        "printf",
        "vim",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "jsdoc",
        "typescript",
        "tsx",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "rust",
        "python",
        "c",
        "cpp",
        "java",
        "dockerfile",
        "sql",
        "bash",
        "php",
        "php_only",
        "phpdoc",
        "blade",
        "go",
        "gomod",
        "gosum",
        "gowork",
      },
    },
  },

  -- git support in nvimtree
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = { enable = true },
      renderer = {
        highlight_git = true,
        icons = { show = { git = true } },
      },
      view = { width = 25 },
    },
  },
}
