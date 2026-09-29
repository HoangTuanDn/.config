-- plugins that NvChad does not ship

---@type NvPluginSpec[]
local plugins = {
  -- "jk" / "jj" escape insert mode without delaying every typed "j"
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {},
  },

  -- Pocco81/auto-save.nvim is unmaintained, okuuva/auto-save.nvim is its maintained fork
  {
    "okuuva/auto-save.nvim",
    version = "^1.0.0",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      -- only real files: writing an oil buffer would apply its pending renames/deletes
      condition = function(buf)
        return vim.bo[buf].buftype == ""
      end,
    },
  },

  -- codota/tabnine-nvim is archived (no more updates)
  -- not loaded on startup, any :Tabnine* command loads it
  {
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh",
    cmd = { "TabnineStatus", "TabnineEnable", "TabnineLogin", "TabnineChat" },
    main = "tabnine",
    opts = {
      disable_auto_comment = true,
      accept_keymap = "<M-Tab>",
      dismiss_keymap = "<M-Esc>",
      debounce_ms = 800,
      suggestion_color = { gui = "#808080", cterm = 244 },
      exclude_filetypes = { "TelescopePrompt" },
      log_file_path = nil, -- absolute path to Tabnine log file
    },
  },

  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      {
        "-",
        function()
          require("oil").open_float()
        end,
        desc = "Open Oil (press '-' again for parent dir)",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
  },

  -- visual multi
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-l>",
        ["Find Subword Under"] = "<C-l>",
      }
    end,
  },

  -- live server, now pure lua: the npm live-server package is no longer needed
  -- its GitHub repo (barrett-ruth/live-server.nvim) is removed on 2026-10-31, it moved to Forgejo
  {
    url = "https://forge.barrettruth.com/barrettruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html", "css", "javascript" },
        callback = function(args)
          vim.keymap.set("n", "=", "<cmd>LiveServerStart<CR>", { buffer = args.buf, desc = "Start Live Server" })
          vim.keymap.set("n", "<C-=>", "<cmd>LiveServerStop<CR>", { buffer = args.buf, desc = "Stop Live Server" })
        end,
      })
    end,
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapToggleBreakpoint", "DapContinue", "DapNew" },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
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

      -- php: needs the xdebug extension (xdebug.mode=debug, xdebug.start_with_request=yes), go: nvim-dap-go
      dap.adapters.php = { type = "executable", command = "php-debug-adapter" }
      dap.configurations.php = {
        { type = "php", request = "launch", name = "Listen for Xdebug", port = 9003 },
      }
    end,
  },

  -- surround
  {
    "kylechui/nvim-surround",
    version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },

  -- preview documentation (mappings are in lua/mappings.lua)
  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    opts = function()
      return {
        width = 120, -- Width of the floating window
        height = 15, -- Height of the floating window
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
          provider = "telescope",
          telescope = require("telescope.themes").get_dropdown { hide_preview = false },
        },
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
        stack_floating_preview_windows = true, -- Whether to nest floating windows
        preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
      }
    end,
  },

  -- colorizer: NvChad/nvim-colorizer.lua moved to catgoose/nvim-colorizer.lua
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      options = {
        parsers = {
          css = true, -- Enable all CSS features: names, hex, rgb(), hsl(), oklch(), var()
          css_fn = true, -- Enable all CSS *functions*: rgb(), hsl(), oklch()
          names = { enable = true }, -- "Name" codes like Blue or blue
          hex = {
            rgb = true, -- #RGB hex codes
            rrggbb = true, -- #RRGGBB hex codes
            rrggbbaa = true, -- #RRGGBBAA hex codes
            aarrggbb = true, -- 0xAARRGGBB hex codes
          },
          rgb = { enable = true }, -- CSS rgb() and rgba() functions
          hsl = { enable = true }, -- CSS hsl() and hsla() functions
          tailwind = { enable = true }, -- Enable tailwind colors
          sass = { enable = true, parsers = { css = true } }, -- Enable sass colors
        },
        display = {
          mode = "background", -- background / foreground / underline / virtualtext
          virtualtext = { char = "■" },
        },
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = true,
      },
    },
  },
}

return plugins
