return {
  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "topazape/md-preview.nvim",
    ft = { "markdown" },
    cmd = { "MPToggle", "MPOpen", "MPClose", "MPRefresh" },
    keys = {
      { "<leader>cp", "<cmd>MPToggle<cr>", ft = "markdown", desc = "Markdown Preview" },
    },
    main = "md-preview",
    opts = {
      viewer = {
        exec = "glow",
        args = { "-s", "dark" },
      },
    },
  },
}
