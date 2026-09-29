-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "flexoki",
  theme_toggle = { "flexoki", "one_light" },

  -- To find any highlight groups: "<cmd> Telescope highlights"
  -- Each highlight group can take a table with variables fg, bg, bold, italic, etc
  -- base30 variable names can also be used as colors
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },

  hl_add = {
    NvimTreeOpenedFolderName = { fg = "green", bold = true },
  },

  integrations = {},
}

M.ui = {
  cmp = {
    style = "atom", -- default/flat_light/flat_dark/atom/atom_colored
  },

  telescope = { style = "borderless" }, -- borderless / bordered

  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
    separator_style = "block",
  },

  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "treeOffset", "buffers", "tabs", "btns" },
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    "01010100 01101000 01101001 01110011 ",
    "00100000 01110100 01101111 01101111 ",
    "00100000 01110011 01101000 01100001 ",
    "01101100 01101100 00100000 01110000 ",
    "01100001 01110011 01110011 00101110 ",
    "00101110 00101110 01011100 00110000 ",
  },
}

M.lsp = { signature = false }

-- colors are highlighted by nvim-colorizer.lua (see plugins/cst.lua)
M.colorify = { enabled = false }

-- :MasonInstallAll already installs every server passed to vim.lsp.enable
-- and every formatter used by conform, these are the extras
M.mason = {
  pkgs = {
    "tree-sitter-cli", -- needed by nvim-treesitter (main branch) to build parsers
    "docker-language-server", -- not in NvChad's lsp -> mason name table yet
    -- go: linter used by golangci_lint_ls, debugger, gopher.nvim tools
    "golangci-lint",
    "delve",
    "gomodifytags",
    "impl",
    "gotests",
    "iferr",
    -- php: xdebug adapter for nvim-dap
    "php-debug-adapter",
  },
  -- needs python < 3.14, install it outside mason if you need nginx lsp
  skip = { "nginx-language-server" },
}

return M
