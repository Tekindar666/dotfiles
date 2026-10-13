-- Personal mappings and startup wiring; bridge behavior is tested in pi.nvim.
local calls = {}
local pi = {}
for _, method in ipairs({ "add_context", "prompt", "submit", "add_diagnostics", "add_hover" }) do
  pi[method] = function()
    table.insert(calls, method)
  end
end
package.loaded["pi"] = pi
dofile(".config/nvim/lua/config/keymaps.lua")
local mappings = { pa = "add_context", pp = "prompt", ps = "submit", pd = "add_diagnostics", ph = "add_hover" }
for keys, method in pairs(mappings) do
  for _, mode in ipairs({ "n", "x" }) do
    local mapping = vim.fn.maparg(" " .. keys, mode, false, true)
    assert(type(mapping.callback) == "function", "Missing Pi mapping: " .. keys)
    mapping.callback()
    assert(calls[#calls] == method)
  end
end
assert(vim.fn.maparg(" p<CR>", "n") == "")
local spec = dofile(".config/nvim/lua/plugins/pi.lua")[1]
assert(spec[1] == "Tekindar666/pi.nvim")
assert(spec.lazy == false)
assert(spec.main == "pi")
assert(type(spec.opts) == "table")
local ui = dofile(".config/nvim/lua/plugins/ui.lua")
for _, plugin in ipairs(ui) do
  if plugin[1] == "nvim-lualine/lualine.nvim" then
    assert(vim.tbl_contains(plugin.dependencies, "Tekindar666/pi.nvim"))
  end
end
print("Pi package configuration and personal keymaps passed")
