require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
-- "jk" to escape insert mode comes from better-escape.nvim (a plain "jk" mapping delays every typed "j")

-- VSCode-style move & duplicate lines...
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-l>", "yyp", { desc = "Duplicate line" })

-- ... and same for blocks
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move block up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
map("v", "<A-l>", "Vy0P", { desc = "Duplicate block" })

-- dap
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Dap toggle breakpoint" })
map("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Dap start / continue" })
map("n", "<leader>do", function()
  require("dap").step_over()
end, { desc = "Dap step over" })
map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Dap step into" })
map("n", "<leader>dO", function()
  require("dap").step_out()
end, { desc = "Dap step out" })
map("n", "<leader>dq", function()
  require("dap").terminate()
end, { desc = "Dap stop" })
map("n", "<leader>du", function()
  require "dap" -- loads nvim-dap, its config sets up dap-ui
  require("dapui").toggle()
end, { desc = "Dap toggle ui" })
map("n", "<leader>dt", function()
  require("dap-go").debug_test()
end, { desc = "Dap debug go test under cursor" })

-- goto preview
map("n", "gpd", function()
  require("goto-preview").goto_preview_definition()
end, { desc = "Preview definition" })
map("n", "gpt", function()
  require("goto-preview").goto_preview_type_definition()
end, { desc = "Preview type definition" })
map("n", "gpi", function()
  require("goto-preview").goto_preview_implementation()
end, { desc = "Preview implementation" })
map("n", "gpD", function()
  require("goto-preview").goto_preview_declaration()
end, { desc = "Preview declaration" })
map("n", "gpr", function()
  require("goto-preview").goto_preview_references()
end, { desc = "Preview references" })
map("n", "gP", function()
  require("goto-preview").close_all_win()
end, { desc = "Close all preview windows" })

--
map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, { desc = "telescope live grep" })
