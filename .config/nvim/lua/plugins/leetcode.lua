return {
  "kawre/leetcode.nvim",
  cmd = "Leet",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    {
      "3rd/image.nvim",
      build = false,
      opts = {
        backend = "kitty",
        processor = "magick_cli",
      },
    },
  },
  opts = {
    lang = "typescript",
    cn = { enabled = false },
    picker = { provider = "snacks-picker" },
    plugins = { non_standalone = true },
    image_support = true,
    injector = {
      typescript = {
        before = {
          "class ListNode {",
          "  val: number;",
          "  next: ListNode | null;",
          "",
          "  constructor(val = 0, next: ListNode | null = null) {",
          "    this.val = val;",
          "    this.next = next;",
          "  }",
          "}",
        },
      },
    },
    theme = {
      normal = { fg = "#d8dee9" },
      alt = { fg = "#9aa5b5" },
    },
  },
}
