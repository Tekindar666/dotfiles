-- Run from the repository root: nvim --headless -u NONE -l tests/nvim-hidden-files.lua
-- Requires installed Snacks, fd/fdfind, and Git; searches only temporary fixtures.
local repo = vim.fn.getcwd()
local plugins = vim.env.NVIM_PLUGIN_DIR or (vim.fn.stdpath("data") .. "/lazy")
vim.opt.runtimepath:append(repo .. "/.config/nvim")
vim.opt.runtimepath:append(plugins .. "/snacks.nvim")
require("snacks")
local Async = require("snacks.picker.util.async")
local hidden = require("util.hidden-files")
local temp = vim.fn.tempname()
local root = temp .. "/.hidden-parent/project"
vim.fn.mkdir(root, "p")
local errors = {}
vim.notify = function(message, level)
  if level == vim.log.levels.ERROR then
    errors[#errors + 1] = message
  end
end

local function file(name, lines)
  vim.fn.mkdir(vim.fs.dirname(root .. "/" .. name), "p")
  vim.fn.writefile(lines or { "fixture" }, root .. "/" .. name)
end

local function git(...)
  local result = vim.system({ "git", "-C", root, ... }, { text = true }):wait()
  assert(result.code == 0, result.stderr)
end

local function collect(cwd, cancel)
  local results = {}
  local ctx = { picker = { opts = { debug = {} } } }
  local finder = hidden.finder({ cwd = cwd }, ctx)
  local done = false
  local task = Async.new(function()
    finder(function(item)
      assert(item.cwd == cwd and item.file == item.text)
      assert(not results[item.file], "Duplicate: " .. item.file)
      results[item.file] = true
      if cancel then
        Async.running():abort()
      end
    end)
  end)
  task:on("error", function(err)
    errors[#errors + 1] = err
  end)
  task:on("done", function()
    done = true
  end)
  assert(
    vim.wait(5000, function()
      return done
    end),
    "Finder timed out"
  )
  assert(#errors == 0, vim.inspect(errors))
  return results, task
end

local ok, err = xpcall(function()
  git("init", "--quiet")
  file(".gitignore", { "build/*", "!build/keep.txt", ".env", "tracked.log" })
  file(".env")
  file(".config/settings.json")
  file("src/.nested/config")
  file("src/visible.ts")
  file("untracked.txt")
  file("build/output.txt")
  file("build/keep.txt")
  file("tracked.log")
  file(".space and\nnewline")
  git("add", "-f", "tracked.log", "src/visible.ts", ".config/settings.json")
  local items = collect(root)
  for _, name in ipairs({
    ".git/HEAD",
    ".gitignore",
    ".env",
    ".config/settings.json",
    "src/.nested/config",
    "build/output.txt",
    ".space and\nnewline",
  }) do
    assert(items[name], "Missing: " .. name)
  end
  for _, name in ipairs({ "src/visible.ts", "untracked.txt", "build/keep.txt", "tracked.log" }) do
    assert(not items[name], "Unexpected: " .. name)
  end

  local cancelled, task = collect(root, true)
  assert(task:aborted())
  assert(vim.tbl_count(cancelled) == 1)

  local plain = temp .. "/plain"
  vim.fn.mkdir(plain, "p")
  vim.fn.writefile({}, plain .. "/.env")
  vim.fn.writefile({}, plain .. "/visible.txt")
  assert(vim.deep_equal({ [".env"] = true }, collect(plain)))

  -- Exercise the actual keymap without opening or moving the user's editor.
  local captured
  _G.LazyVim = {
    root = function()
      return root
    end,
  }
  Snacks.picker = function(opts)
    captured = opts
  end
  dofile(repo .. "/.config/nvim/lua/config/keymaps.lua")
  vim.fn.maparg(" fh", "n", false, true).callback()
  assert(captured.cwd == root and captured.finder == hidden.finder and captured.format == "file")
  assert(vim.fn.maparg(" fi", "n", false, true).desc == "Find Import Path")
end, debug.traceback)

vim.fn.delete(temp, "rf")
assert(ok, err)
print("Hidden/Git-ignored picker checks passed")
