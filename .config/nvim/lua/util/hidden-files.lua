local M = {}

--- Finds hidden paths (any dot-prefixed component) plus Git-ignored files.
--- Uses Snacks' process runner so closing the picker cancels discovery.
---@type snacks.picker.finder
function M.finder(opts, ctx)
  local cwd = opts.cwd or vim.uv.cwd()
  local fd = require("snacks.picker.source.files").get_fd()
  if not fd then
    return function() end
  end
  local git_root = vim.fs.root(cwd, ".git")
  local proc = require("snacks.picker.source.proc").proc

  return function(cb)
    local seen = {}
    local function add(item)
      local path = item.text:gsub("^%./", "")
      if not seen[path] then
        seen[path] = true
        item.text, item.file, item.cwd = path, path, cwd
        cb(item)
      end
    end

    -- Do not use the normal files source: it always excludes .git.
    proc({
      cmd = fd,
      args = { "--hidden", "--no-ignore", "--type", "f", "--type", "l", "--color", "never", "--print0" },
      cwd = cwd,
      sep = "\0",
    }, ctx)(function(item)
      local path = item.text:gsub("^%./", "")
      if path:sub(1, 1) == "." or path:find("/.", 1, true) then
        add(item)
      end
    end)

    -- One batched Git query, not a process per file. Outside Git, show hidden files only.
    if git_root then
      proc({
        cmd = "git",
        args = { "ls-files", "--others", "--ignored", "--exclude-standard", "-z" },
        cwd = cwd,
        sep = "\0",
      }, ctx)(add)
    end
  end
end

function M.open()
  Snacks.picker({
    title = "Hidden and Git-Ignored Files",
    cwd = LazyVim.root(),
    finder = M.finder,
    format = "file",
  })
end

return M
