-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- toggle inlay hints
keymap.set("n", "<leader>i", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- exit terminal mode with Alt-n
keymap.set("t", "<A-n>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- double escape to exit terminal mode
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- open oil with -
keymap.set("n", "-", "<cmd>Oil<CR>")

keymap.set({ "n", "x" }, "<leader>pa", function()
  require("util.pi").add_context()
end, { desc = "Add Context to Pi Draft" })

keymap.set({ "n", "x" }, "<leader>pp", function()
  require("util.pi").prompt()
end, { desc = "Add Prompt to Pi Draft" })

keymap.set({ "n", "x" }, "<leader>p<CR>", function()
  require("util.pi").submit()
end, { desc = "Submit Pi Draft" })

keymap.set({ "n", "x" }, "<leader>pd", function()
  require("util.pi").add_diagnostics()
end, { desc = "Add Diagnostics to Pi" })

keymap.set({ "n", "x" }, "<leader>ph", function()
  require("util.pi").add_hover()
end, { desc = "Add LSP Hover to Pi" })

-- copy the current file's project-relative path
keymap.set("n", "<leader>yp", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Current buffer has no file", vim.log.levels.WARN)
    return
  end

  local path = vim.fs.relpath(LazyVim.root(), file) or file
  vim.fn.setreg("+", path)
  vim.notify("Copied " .. path)
end, { desc = "Yank File Path" })

keymap.set("n", "<leader>fh", function()
  require("util.hidden-files").open()
end, { desc = "Find Hidden and Git-Ignored Files" })

-- copy a selected file's import path relative to the current file
keymap.set("n", "<leader>fi", function()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    vim.notify("Current buffer has no file", vim.log.levels.WARN)
    return
  end

  local current_dir = vim.fs.dirname(current_file)
  local root = LazyVim.root()
  Snacks.picker.files({
    cwd = root,
    ignored = false,
    title = "Copy Relative Import Path",
    confirm = function(picker, item)
      picker:close()
      local target = Snacks.picker.util.path(item)
      local source_path = vim.fs.relpath(root, current_dir)
      local target_path = target and vim.fs.relpath(root, target)
      if not source_path or not target_path then
        vim.notify("Could not calculate relative import path", vim.log.levels.ERROR)
        return
      end

      local source_parts = source_path == "." and {} or vim.split(source_path, "/", { plain = true })
      local target_parts = vim.split(target_path, "/", { plain = true })
      local shared = 1
      while source_parts[shared] and source_parts[shared] == target_parts[shared] do
        shared = shared + 1
      end

      local relative_parts = {}
      for _ = shared, #source_parts do
        table.insert(relative_parts, "..")
      end
      for index = shared, #target_parts do
        table.insert(relative_parts, target_parts[index])
      end

      local relative = table.concat(relative_parts, "/"):gsub("%.ts$", "")
      if not vim.startswith(relative, "../") then
        relative = "./" .. relative
      end

      vim.fn.setreg("+", relative)
      vim.notify("Copied " .. relative)
    end,
  })
end, { desc = "Find Import Path" })

-- visual mode mappings
keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
vim.keymap.set("v", "<leader>C", "gc", { desc = "Comment/uncomment selection", remap = true })
