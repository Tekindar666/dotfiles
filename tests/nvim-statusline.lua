local plugins = vim.env.NVIM_PLUGIN_DIR or (vim.fn.stdpath("data") .. "/lazy")
vim.opt.runtimepath:append(plugins .. "/lualine.nvim")
package.loaded["pi"] = {
  setup = function() end,
  status = function()
    return "Pi test"
  end,
}
local specs = dofile(".config/nvim/lua/plugins/ui.lua")
for _, spec in ipairs(specs) do
  if spec[1] == "nvim-lualine/lualine.nvim" then
    spec.config()
  end
end
local lualine = require("lualine")
local config = lualine.get_config()
assert(config.sections.lualine_b[1] == "diff")
assert(config.sections.lualine_x[1] == "lsp_status")
assert(config.sections.lualine_y[1][1] == "diagnostics")
local lsp = require("lualine.components.lsp_status")({})
assert(lsp:update_status() == "")
local get_clients = vim.lsp.get_clients
vim.lsp.get_clients = function()
  return { { id = 1, name = "lua_ls" } }
end
assert(lsp:update_status() == "lua_ls")
vim.lsp.get_clients = get_clients
local counts
local diff = require("lualine.components.diff")({
  self = { section = "b" },
  source = function()
    return counts
  end,
})
assert(diff:update_status(true) == "")
counts = { added = 2, modified = 3, removed = 1 }
local status = diff:update_status(true)
assert(status:find("+2", 1, true) and status:find("~3", 1, true) and status:find("-1", 1, true))
print("nvim-statusline: config, LSP name and diff counts/empty states passed")
