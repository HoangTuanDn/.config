local overrides = require "custom.configs.overrides"

local edit_events = {
  "TextChanged",
  "TextChangedI",
  "BufEnter",
  "BufWinEnter",
  "BufLeave",
  "InsertEnter",
  "InsertChange",
  "InsertLeave",
  "BufNewFile",
  "BufReadPre",
  "BufRead",
  "BufReadPost",
  "FileReadPre",
  "FileReadPost",
}

--@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    event = edit_events, -- override to ensure lsp automatically on new/open file
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "NvChad/nvim-colorizer.lua",
    opts = overrides.colorizer,
  },

  ----------------------------------------------------------------
  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "Pocco81/auto-save.nvim",
    cmd = { "ASToggle" },
    -- lazy = false,
    event = edit_events,
    config = function()
      require("auto-save").setup()
    end,
  },

  {
    "codota/tabnine-nvim",
    -- event = edit_events,
    -- lazy = false,
    config = function()
      require("tabnine").setup {
        disable_auto_comment = true,
        accept_keymap = "<M-Tab>",
        dismiss_keymap = "<M-Esc>",
        debounce_ms = 800,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt" },
        log_file_path = nil, -- absolute path to Tabnine log file
      }
    end,
    build = "./dl_binaries.sh",
  },

  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 4,
        max_width = 100,
        max_height = 80,
      },
    },
    init = function()
      vim.keymap.set("n", "-", require("oil").open_float, { desc = "Open Oil (press '-' again for parent dir)" })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(this)
      require("oil").setup(this.opts)
    end,
  },
  -- visual multi
  {
    "mg979/vim-visual-multi",
    event = edit_events,
    init = function()
      vim.cmd "let g:VM_maps = {}"
      vim.cmd "let g:VM_maps['Find Under'] = '<C-l>'"
      vim.cmd "let g:VM_maps['Find Subword Under'] = '<C-l>'"
    end,
  },
  -- live server
  {
    "barrett-ruth/live-server.nvim",
    build = "npm i -g live-server",
    ft = { "html", "css", "javascript" },
    init = function()
      vim.keymap.set("n", "=", ":LiveServerStart<CR>", { desc = "Start Live Server" })
      vim.keymap.set("n", "<C-=>", ":LiveServerStop<CR>", { desc = "Stop Live Server" })
    end,
    config = function()
      require("live-server").setup()
    end,
  },

  -- dap 
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("core.utils").load_mappings "dap"
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  -- surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  -- preview documentation
  {
    'rmagatti/goto-preview',
    opt = overrides.gotoPreview,
    config = function(this)
      require('goto-preview').setup {this.opt}
    end
  }
}

return plugins