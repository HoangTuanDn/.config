require "nvchad.options"

-- add yours here!

-- docker_compose_language_service only attaches to this filetype, neovim detects these files as plain yaml
-- (yamlls and treesitter keep working, they handle "yaml.docker-compose" as yaml)
vim.filetype.add {
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
}

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
