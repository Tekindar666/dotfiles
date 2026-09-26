return {
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader>h",
        function()
          local harpoon = require("harpoon")
          local list = harpoon:list()
          local width = math.max(1, math.min(90, math.floor(vim.o.columns * 0.7), vim.o.columns - 4))
          local height = math.max(1, math.min(math.max(3, list:length()), 12, vim.o.lines - 4))

          harpoon.ui:toggle_quick_menu(list, {
            border = "rounded",
            title = " Harpoon ",
            title_pos = "center",
            ui_width_ratio = 0.7,
            ui_fallback_width = width,
            ui_max_width = width,
            height_in_lines = height,
          })

          local win = harpoon.ui.win_id
          if not win or not vim.api.nvim_win_is_valid(win) then
            return
          end

          -- Reapply on open so a colorscheme reload cannot leave stale highlights.
          vim.api.nvim_set_hl(0, "HarpoonMenuBorder", { fg = "#88C0D0" })
          vim.api.nvim_set_hl(0, "HarpoonMenuTitle", { fg = "#88C0D0", bold = true })
          vim.api.nvim_set_hl(0, "HarpoonMenuNumber", { fg = "#BBC3D4" })
          vim.api.nvim_set_hl(0, "HarpoonMenuSelection", { bg = "#3B4252" })

          local wo = vim.wo[win]
          wo.winhighlight = table.concat({
            "Normal:NormalFloat",
            "FloatBorder:HarpoonMenuBorder",
            "FloatTitle:HarpoonMenuTitle",
            "LineNr:HarpoonMenuNumber",
            "CursorLineNr:HarpoonMenuTitle",
            "CursorLine:HarpoonMenuSelection",
          }, ",")
          -- Numbers are Harpoon slots; decoration must never change editable paths.
          wo.number = true
          wo.relativenumber = false
          wo.numberwidth = 3
          wo.statuscolumn = ""
          wo.signcolumn = "no"
          wo.foldcolumn = "0"
          wo.cursorline = true
          wo.cursorlineopt = "both"
          wo.wrap = false
          wo.scrolloff = 0
        end,
        desc = "Harpoon Quick Menu",
      },
    },
  },
}
