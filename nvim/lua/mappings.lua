require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<A-k", ":m .-2<CR>==")
map("n", "<A-j", ":m .+1<CR>==")
map("n", "<A-l", "yyp")

map("v", "<A-k", ":m '<-2<CR>gv=gv")
map("v", "<A-j", ":m '>+1<CR>gv=gv")
map("v", "<A-l", "Vy0P")

map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>")

-- goto preview
map("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})
map("n", "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", {noremap=true})
map("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", {noremap=true})
map("n", "gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", {noremap=true})
map("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", {noremap=true})
map("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", {noremap=true})
