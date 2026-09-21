-- Run from the repository root: nvim --headless -u NONE -l tests/nvim-pi.lua
vim.opt.runtimepath:append(vim.fn.getcwd() .. "/.config/nvim")

local requests = {}
local notifications = {}
local input = "Explain the selection"
local reader
local submitted = true

vim.notify = function(message)
  table.insert(notifications, message)
end
vim.ui.input = function(_, callback)
  callback(input)
end
vim.system = function()
  return {
    wait = function()
      return { code = 0, stdout = "/test/pi.sock" }
    end,
  }
end
vim.env.TMUX_PANE = "%test"
vim.uv.new_pipe = function()
  return {
    connect = function(_, _, callback)
      callback()
    end,
    read_start = function(_, callback)
      reader = callback
    end,
    write = function(_, data)
      local message = vim.json.decode(data)
      if message.type == "register" then
        return
      end
      table.insert(requests, message)
      reader(nil, vim.json.encode({
        version = 1,
        type = "response",
        id = message.id,
        ok = true,
        result = { submitted = submitted },
      }) .. "\n")
    end,
    is_closing = function()
      return false
    end,
    close = function() end,
  }
end

local function equal(expected, actual)
  assert(vim.deep_equal(expected, actual), vim.inspect({ expected = expected, actual = actual }))
end

local function invoke(mode, keys)
  local mapping = vim.fn.maparg(keys, mode, false, true)
  assert(type(mapping.callback) == "function", "Missing mapping: " .. keys)
  mapping.callback()
  vim.wait(20, function()
    return false
  end)
end

local function select_lines()
  vim.api.nvim_feedkeys("ggVj", "xt", false)
  equal("V", vim.fn.mode())
end

vim.api.nvim_buf_set_name(0, "/test/example.lua")
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "local value = 1", "print(value)" })
dofile(".config/nvim/lua/config/keymaps.lua")

invoke("n", " pa")
equal("draft", requests[#requests].type)
equal("Neovim context", requests[#requests].label)
equal(nil, requests[#requests].context.selection)

select_lines()
invoke("x", " pa")
equal("draft", requests[#requests].type)
equal(1, requests[#requests].context.selection.start.line)
equal(2, requests[#requests].context.selection["end"].line)

invoke("x", " pp")
equal("draft", requests[#requests].type)
equal("Explain the selection", requests[#requests].content)
equal(1, requests[#requests].context.selection.start.line)
equal(2, requests[#requests].context.selection["end"].line)
equal("n", vim.fn.mode())

input = nil
local before_cancel = #requests
invoke("n", " pp")
equal(before_cancel, #requests)
input = "  "
invoke("n", " pp")
equal(before_cancel, #requests)

input = "Explain the file"
invoke("n", " pp")
equal("draft", requests[#requests].type)
equal("Explain the file", requests[#requests].content)

local namespace = vim.api.nvim_create_namespace("pi-test")
vim.diagnostic.set(namespace, 0, {
  { lnum = 1, col = 0, severity = vim.diagnostic.severity.ERROR, message = "Test diagnostic" },
})
invoke("n", " pd")
equal("draft", requests[#requests].type)
equal("Neovim diagnostics", requests[#requests].label)

local get_clients = vim.lsp.get_clients
vim.lsp.get_clients = function()
  return {
    {
      name = "test",
      offset_encoding = "utf-16",
      request_sync = function()
        return { result = { contents = "Test hover" } }
      end,
    },
  }
end
invoke("n", " ph")
vim.lsp.get_clients = get_clients
equal("draft", requests[#requests].type)
equal("Neovim LSP hover", requests[#requests].label)

for _, request in ipairs(requests) do
  equal("draft", request.type)
end
invoke("n", " p\r")
equal("submit", requests[#requests].type)
equal("Pi draft submitted", notifications[#notifications])
equal("Pi ●", require("util.pi").status())

submitted = false
invoke("x", " p\r")
equal("submit", requests[#requests].type)
equal("Pi draft is empty", notifications[#notifications])
print("Pi draft keymap checks passed")
