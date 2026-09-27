local function harpoon_picker_items(list)
  local items = {}
  local cwd = vim.uv.cwd()

  for index = 1, list:length() do
    local item = list:get(index)
    if item and item.value and item.value ~= "" then
      table.insert(items, {
        text = item.value,
        file = item.value,
        cwd = cwd,
        harpoon_index = index,
      })
    end
  end

  return items
end

return {
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader>h",
        function()
          local list = require("harpoon"):list()
          local items = harpoon_picker_items(list)

          if #items == 0 then
            vim.notify("Harpoon list is empty", vim.log.levels.INFO)
            return
          end

          require("snacks").picker({
            title = "Harpoon",
            items = items,
            format = "file",
            preview = "file",
            confirm = function(picker, item)
              picker:close()
              if item then
                list:select(item.harpoon_index)
              end
            end,
          })
        end,
        desc = "Harpoon Picker",
      },
      {
        "<leader>he",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Edit Menu",
      },
    },
  },
}
