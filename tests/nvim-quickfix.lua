-- Run from the repository root: nvim --headless -u NONE -l tests/nvim-quickfix.lua
-- Uses real Trouble in an isolated Neovim process, without personal config or state.
local root = vim.fn.getcwd()
local plugins = vim.env.NVIM_PLUGIN_DIR or (vim.fn.stdpath("data") .. "/lazy")
vim.opt.runtimepath:append(root .. "/.config/nvim")
vim.opt.runtimepath:append(plugins .. "/trouble.nvim")
vim.o.columns = 80
vim.o.hidden = true

local function equal(expected, actual)
  assert(vim.deep_equal(expected, actual), vim.inspect({ expected = expected, actual = actual }))
end

local spec
for _, plugin in ipairs(require("plugins.editor")) do
  if plugin[1] == "folke/trouble.nvim" then
    spec = plugin
  end
end
assert(spec, "Trouble configuration is missing")
local trouble = require("trouble")
trouble.setup(spec.opts)
local config = require("trouble.config")
local diagnostics_before = vim.deepcopy(config.get("diagnostics"))
local symbols_before = vim.deepcopy(config.get("symbols"))

local source = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_name(source, root .. "/reading-set-unsaved.lua")
vim.api.nvim_buf_set_lines(source, 0, -1, false, { "-- unsaved work", "local example = true" })
local tick = vim.api.nvim_buf_get_changedtick(source)
local long_note = "First: read the entry point before the implementation. "
  .. "This deliberately long explanation must wrap so the reader can see the complete message without scrolling sideways."
local items = {
  { filename = root .. "/.config/nvim/lua/util/pi.lua", lnum = 142, col = 1, text = long_note, type = "N" },
  {
    filename = root .. "/.config/nvim/lua/plugins/editor.lua",
    lnum = 1,
    col = 1,
    text = "Second: display options",
    type = "E",
  },
  {
    filename = root .. "/.config/nvim/lua/util/pi.lua",
    lnum = 127,
    col = 1,
    text = "Third: return to the earlier helper",
    type = "I",
  },
}
vim.fn.setqflist({}, " ", { title = "Reading order", items = items })

for _, mode in ipairs({ "quickfix", "qflist" }) do
  local view = assert(trouble.open({ mode = mode, auto_preview = false }))
  local rendered = false
  view:wait(function()
    rendered = true
  end)
  assert(
    vim.wait(2000, function()
      return rendered and view.win.win and #trouble.get_items({ mode = mode }) == #items
    end),
    "Trouble did not render the quickfix entries"
  )
  equal(true, vim.wo[view.win.win].wrap)
  equal(true, vim.wo[view.win.win].linebreak)
  equal({}, config.get(mode).groups)
  local displayed = trouble.get_items({ mode = mode })
  for index, expected in ipairs(items) do
    equal(expected.text, displayed[index].text)
    equal(expected.filename, displayed[index].filename)
    equal({ expected.lnum, expected.col - 1 }, displayed[index].pos)
  end
  local lines = vim.api.nvim_buf_get_lines(view.win.buf, 0, -1, false)
  assert(table.concat(lines, "\n"):find(long_note, 1, true), "The full explanation must be rendered")
  assert(not config.get(mode).format:find(":ts", 1, true), "Notes must not be syntax-highlighted as code")
  view:jump(displayed[3])
  equal(items[3].filename, vim.api.nvim_buf_get_name(0))
  equal({ items[3].lnum, 0 }, vim.api.nvim_win_get_cursor(0))
  trouble.close({ mode = mode })
  vim.api.nvim_set_current_buf(source)
end

-- Quickfix presentation must not affect diagnostics, symbols, or source buffer contents.
equal(diagnostics_before, config.get("diagnostics"))
equal(symbols_before, config.get("symbols"))
equal(tick, vim.api.nvim_buf_get_changedtick(source))
equal(true, vim.bo[source].modified)
equal({ "-- unsaved work", "local example = true" }, vim.api.nvim_buf_get_lines(source, 0, -1, false))
print("Quickfix wrapping, reading order, messages, navigation, and isolation passed")
