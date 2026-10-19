-- ~/.config/nvim/lua/config/autocmds.lua

-- Quit Neovim if the only remaining windows are sidebars (explorer/filetree)
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local function is_real(w)
      local buf = vim.api.nvim_win_get_buf(w)
      local ft = vim.bo[buf].filetype
      local bt = vim.bo[buf].buftype
      return ft ~= "snacks_layout_box" and ft ~= "snacks_picker_list"
        and ft ~= "snacks_picker_input" and ft ~= "snacks_picker_preview"
        and bt ~= "nofile"
    end

    -- Only act when a real window is being quit (ignore plugin/sidebar closes)
    if not is_real(vim.api.nvim_get_current_win()) then return end

    local real = 0
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if is_real(w) then real = real + 1 end
    end
    if real <= 1 then
      vim.cmd("qa")
    end
  end,
})

-- Disable LazyVim's default spell-check for Markdown and Typst
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "typst" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
