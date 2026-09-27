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
