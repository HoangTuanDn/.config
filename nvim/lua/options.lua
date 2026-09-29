require "nvchad.options"

-- add yours here!

-- docker_language_server only handles compose files with this filetype, neovim detects them as plain yaml
-- (yamlls and treesitter keep working, they handle "yaml.docker-compose" as yaml)
vim.filetype.add {
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
}

-- composer global tools, e.g. laravel-lsp (composer global require laravel/lsp)
local composer_bin = (vim.env.COMPOSER_HOME or vim.fn.expand "~/.config/composer") .. "/vendor/bin"
if vim.uv.fs_stat(composer_bin) then
  vim.env.PATH = vim.env.PATH .. ":" .. composer_bin
end

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
