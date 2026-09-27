require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- treesitter indent (was `indent = { enable = true }` in the old nvim-treesitter setup)
-- nvchad.autocmds already starts treesitter highlighting for every filetype
autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang and vim.treesitter.language.add(lang) and vim.treesitter.query.get(lang, "indents") then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- the autocmds below come from lua/custom/init.lua, which NvChad v2.5 never loaded

-- Load classic vim spell check
autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function(args)
    if vim.bo[args.buf].buftype == "" then
      vim.opt_local.spell = true
      vim.opt_local.spelllang = { "en_us" }
    end
  end,
})

-- Show the nvim-tree upon open
-- after NvChad's FilePost (fired for the first real file), a focused tree at startup would block that event
autocmd("User", {
  pattern = "FilePost",
  once = true,
  callback = function()
    require("nvim-tree.api").tree.toggle { focus = false }
  end,
})

-- Fix null-ls/lsp formatter ('gq') issue: LSP sets 'formatexpr' on attach, keep gq on vim's own formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131#issuecomment-1457584752
autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].formatexpr = nil
  end,
})
