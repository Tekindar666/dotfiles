-- Run from the repository root: nvim --headless -u NONE -l tests/nvim-harpoon-ui.lua
-- Uses real Harpoon with isolated data; never reads or writes personal bookmarks.
local repo = vim.fn.getcwd()
local plugins = vim.env.NVIM_PLUGIN_DIR or (vim.fn.stdpath("data") .. "/lazy")
vim.opt.runtimepath:append(repo .. "/.config/nvim")
vim.opt.runtimepath:append(plugins .. "/plenary.nvim")
vim.opt.runtimepath:append(plugins .. "/harpoon")
local temp = vim.fn.tempname()
vim.fn.mkdir(temp .. "/data/nvim", "p")
vim.env.XDG_DATA_HOME = temp .. "/data"

local function equal(expected, actual)
  assert(vim.deep_equal(expected, actual), vim.inspect({ expected = expected, actual = actual }))
end

local picker_opts
local picker_closed = false
local notifications = {}
local Snacks = {
  picker = function(opts)
    picker_opts = opts
  end,
}
package.loaded["snacks"] = Snacks
_G.Snacks = Snacks

local original_notify = vim.notify
vim.notify = function(message, level)
  table.insert(notifications, { message = message, level = level })
end

local ok, err = xpcall(function()
  vim.api.nvim_set_current_dir(temp)
  local harpoon = require("harpoon")
  local inherited = dofile(plugins .. "/LazyVim/lua/lazyvim/plugins/extras/editor/harpoon2.lua")
  harpoon:setup(inherited.opts)
  local spec = require("plugins.harpoon")[1]
  equal("<leader>h", spec.keys[1][1])
  equal("Harpoon Picker", spec.keys[1].desc)
  equal("<leader>he", spec.keys[2][1])
  equal("Harpoon Edit Menu", spec.keys[2].desc)
  local open_picker = spec.keys[1][2]
  local list = harpoon:list()

  open_picker()
  equal(nil, picker_opts)
  equal("Harpoon list is empty", notifications[1].message)
  equal(vim.log.levels.INFO, notifications[1].level)

  vim.fn.writefile({ "personal" }, "personal.ts")
  vim.fn.writefile({ "managed" }, "managed.ts")
  list:add({ value = "personal.ts", context = { row = 1, col = 0 } })
  list:add({ value = "managed.ts", context = { row = 1, col = 0, pi_working_set = true } })
  local before = vim.deepcopy(list.items)

  open_picker()
  equal("Harpoon", picker_opts.title)
  equal("file", picker_opts.format)
  equal("file", picker_opts.preview)
  equal({ "personal.ts", "managed.ts" }, vim.tbl_map(function(item)
    return item.text
  end, picker_opts.items))
  equal({ "personal.ts", "managed.ts" }, vim.tbl_map(function(item)
    return item.file
  end, picker_opts.items))
  equal({ 1, 2 }, vim.tbl_map(function(item)
    return item.harpoon_index
  end, picker_opts.items))
  equal(temp, picker_opts.items[1].cwd)
  equal(before, list.items)
  equal(nil, harpoon.ui.win_id)

  picker_opts.confirm({ close = function()
    picker_closed = true
  end }, picker_opts.items[2])
  equal(true, picker_closed)
  equal("managed.ts", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"))

  list:remove_at(1)
  picker_opts = nil
  open_picker()
  equal({ "managed.ts" }, vim.tbl_map(function(item)
    return item.text
  end, picker_opts.items))
  equal({ 2 }, vim.tbl_map(function(item)
    return item.harpoon_index
  end, picker_opts.items))
end, debug.traceback)

vim.notify = original_notify
vim.api.nvim_set_current_dir(repo)
vim.fn.delete(temp, "rf")
assert(ok, err)
print("Harpoon Snacks picker checks passed")
