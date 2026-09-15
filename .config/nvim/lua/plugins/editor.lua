return {
  -- Snacks picker layout
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = { preset = "ivy_split" },
        ignored = true,
      },
      zen = {
        win = {
          backdrop = {
            transparent = false,
            blend = 90,
          },
        },
      },
    },
  },

  -- Surround text objects
  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    keys = {
      { "gsa", mode = { "n", "x" }, desc = "Add Surround" },
      { "gsd", mode = "n", desc = "Delete Surround" },
      { "gsr", mode = "n", desc = "Replace Surround" },
    },
    opts = {
      keymaps = {
        normal = "gsa",
        normal_cur = false,
        normal_line = false,
        normal_cur_line = false,
        visual = "gsa",
        visual_line = false,
        delete = "gsd",
        change = "gsr",
        change_line = false,
      },
    },
  },

  -- Tmux navigation
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", mode = { "n", "x" } },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", mode = { "n", "x" } },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", mode = { "n", "x" } },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", mode = { "n", "x" } },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      { "<c-h>", "<C-\\><C-n><cmd>TmuxNavigateLeft<cr>", mode = "t" },
      { "<c-j>", "<C-\\><C-n><cmd>TmuxNavigateDown<cr>", mode = "t" },
      { "<c-k>", "<C-\\><C-n><cmd>TmuxNavigateUp<cr>", mode = "t" },
      { "<c-l>", "<C-\\><C-n><cmd>TmuxNavigateRight<cr>", mode = "t" },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- File exploerer
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
      view_options = {
        show_hidden = true,
      },
    },
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },

  -- Code folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open All Folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close All Folds",
      },
    },
  },

  -- Trouble diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
    opts = {
      focus = true,
    },
    cmd = "Trouble",
    keys = {
      { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble document diagnostics" },
      { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
      { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
    },
  },

  -- auto format
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters = {
        shfmt = {
          append_args = { "-i", "2" },
        },
      },
    },
  },

  -- better diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      hi = {
        background = "Normal",
      },
      options = {
        show_source = {
          enabled = true,
        },
        multilines = {
          enabled = true,
        },
        show_all_diags_on_cursorline = true,
        show_diags_only_under_cursor = true,
      },
    },
  },
}
