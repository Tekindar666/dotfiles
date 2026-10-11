return {
  -- Inline git blame
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      -- current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d>",
      current_line_blame_opts = { delay = 300 },
    },
  },

  -- one buffer diff
  {
    "martindur/zdiff.nvim",
    cmd = "Zdiff",
    keys = {
      { "<leader>zd", "<cmd>Zdiff<cr>", desc = "Zdiff (uncommitted)" },
      { "<leader>zD", "<cmd>Zdiff origin/develop<cr>", desc = "Zdiff (vs origin/develop)" },
    },
    opts = {},
  },
}
