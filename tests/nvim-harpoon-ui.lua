-- Run from the repository root: nvim --headless -u NONE -l tests/nvim-harpoon-ui.lua
-- Uses real plugins with isolated data; never reads or writes personal bookmarks.
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

local ok, err = xpcall(function()
  vim.api.nvim_set_current_dir(temp)
  local harpoon = require("harpoon")
  local inherited = dofile(plugins .. "/LazyVim/lua/lazyvim/plugins/extras/editor/harpoon2.lua")
  harpoon:setup(inherited.opts)
  local spec = require("plugins.harpoon")[1]
  equal("<leader>h", spec.keys[1][1])
  local toggle = spec.keys[1][2]
  local list = harpoon:list()

  -- Empty lists still have a usable editable menu; toggling closes it.
  toggle()
  local config = vim.api.nvim_win_get_config(harpoon.ui.win_id)
  equal(3, config.height)
  equal("center", config.title_pos)
  equal(" Harpoon ", config.title[1][1])
  equal("╭", config.border[1])
  toggle()
  equal(nil, harpoon.ui.win_id)
  -- Harpoon saves an empty buffer as one blank slot, not a bookmark.
  equal({}, list.items)
  equal({ "" }, list:display())

  vim.fn.writefile({ "personal" }, "personal.ts")
  vim.fn.writefile({ "managed" }, "managed.ts")
  list:add({ value = "personal.ts", context = { row = 1, col = 0 } })
  list:add({ value = "managed.ts", context = { row = 1, col = 0, pi_working_set = true } })
  local before = vim.deepcopy(list.items)
  vim.wo.relativenumber = true
  local original_win = vim.api.nvim_get_current_win()
  toggle()
  local win, buf = harpoon.ui.win_id, harpoon.ui.bufnr
  equal({ "personal.ts", "managed.ts" }, vim.api.nvim_buf_get_lines(buf, 0, -1, false))
  equal(before, list.items)
  equal(true, vim.wo[win].number)
  equal(false, vim.wo[win].relativenumber)
  equal("", vim.wo[win].statuscolumn)
  equal(true, vim.wo[win].cursorline)
  equal(false, vim.wo[win].wrap)
  equal(true, vim.bo[buf].modifiable)
  equal("no", vim.wo[win].signcolumn)
  assert(vim.wo[win].winhighlight:find("FloatBorder:HarpoonMenuBorder", 1, true))
  equal(tonumber("88C0D0", 16), vim.api.nvim_get_hl(0, { name = "HarpoonMenuBorder" }).fg)

  -- Native editable paths still reorder on close, retaining Pi ownership metadata.
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "managed.ts", "personal.ts" })
  toggle()
  equal("managed.ts", list:get(1).value)
  equal(true, list:get(1).context.pi_working_set)
  equal("personal.ts", list:get(2).value)
  equal(true, vim.wo[original_win].relativenumber)

  -- Native Enter selection still closes the menu and navigates to the chosen file.
  toggle()
  vim.api.nvim_win_set_cursor(harpoon.ui.win_id, { 2, 0 })
  require("harpoon.buffer").run_select_command()
  equal(nil, harpoon.ui.win_id)
  equal("personal.ts", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"))

  -- Slot holes remain visible rather than renumbering surviving bookmarks.
  list:remove_at(1)
  toggle()
  equal({ "", "personal.ts" }, vim.api.nvim_buf_get_lines(harpoon.ui.bufnr, 0, -1, false))
  toggle()
  equal("personal.ts", list:get(2).value)

  for i = 1, 20 do
    list:add({ value = "file-" .. i .. ".ts", context = { row = 1, col = 0 } })
  end
  vim.o.columns = 200
  vim.o.lines = 50
  toggle()
  config = vim.api.nvim_win_get_config(harpoon.ui.win_id)
  equal(90, config.width)
  equal(12, config.height)
  equal(list:length(), vim.api.nvim_buf_line_count(harpoon.ui.bufnr))
  toggle()

  -- Small terminals constrain the float without dropping any entries.
  vim.o.columns = 30
  vim.o.lines = 10
  toggle()
  config = vim.api.nvim_win_get_config(harpoon.ui.win_id)
  equal(21, config.width)
  equal(6, config.height)
  equal(list:length(), vim.api.nvim_buf_line_count(harpoon.ui.bufnr))
  toggle()
end, debug.traceback)

local harpoon = package.loaded.harpoon
if harpoon and harpoon.ui.win_id then
  harpoon.ui:close_menu()
end
vim.api.nvim_set_current_dir(repo)
vim.fn.delete(temp, "rf")
assert(ok, err)
print("Harpoon native UI checks passed")
