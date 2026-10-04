-- UI enhancement plugins: colorscheme, colorizer, statusline
return {
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").setup({
        transparent = {
          bg = false,
          float = false,
        },
      })
      require("nordic").load()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.api.nvim_set_hl(0, "Cursor", { fg = "#242933", bg = "#BBC3D4" })
          vim.api.nvim_set_hl(0, "TermCursor", { link = "Cursor" })
          vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1A1E25" })
          vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFFFF", bold = true })
          vim.api.nvim_set_hl(0, "LineNr", { fg = "#3B4252" })
          vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#3B4252" })
          vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#3B4252" })
          vim.api.nvim_set_hl(0, "DiagnosticLineNrError", { fg = "#C5727A", bold = true })
          vim.api.nvim_set_hl(0, "DiagnosticLineNrWarn", { fg = "#EBCB8B", bold = true })
          vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo", { fg = "#88C0D0", bold = true })
          vim.api.nvim_set_hl(0, "DiagnosticLineNrHint", { fg = "#B1C89D", bold = true })
          vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#242933", underline = true, sp = "#4c566a" })
          vim.api.nvim_set_hl(0, "Visual", { bg = "#3F5071" })
          vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#d8dee9" })
          vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#d8dee9" })
          vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = "#88c0d0", bold = true })
          vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#C5727A" })
          vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#EBCB8B" })
          vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#88C0D0" })
          vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#B1C89D" })
          vim.api.nvim_set_hl(0, "@markup.strong", { fg = "#a3be8c", bold = true })
        end,
      })
      vim.cmd.colorscheme("nordic")
    end,
  },

  -- Lualine statusline (styled to match tmux: transparent, Nord palette, minimal)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local pi = require("util.pi")

      pi.setup()

      local colors = {
        blue = "#88c0d0",
        green = "#a3be8c",
        purple = "#b48ead",
        dim = "#4c566a",
        fg = "#d8dee9",
        bg = "NONE",
      }

      local tmux_theme = {
        normal = {
          a = { fg = colors.purple, bg = colors.bg, gui = "bold" },
          b = { fg = colors.green, bg = colors.bg },
          c = { fg = colors.fg, bg = colors.bg },
          x = { fg = colors.fg, bg = colors.bg },
          y = { fg = colors.fg, bg = colors.bg },
          z = { fg = colors.purple, bg = colors.bg },
        },
        insert = {
          a = { fg = colors.green, bg = colors.bg, gui = "bold" },
        },
        visual = {
          a = { fg = colors.purple, bg = colors.bg, gui = "bold" },
        },
        command = {
          a = { fg = "#ebcb8b", bg = colors.bg, gui = "bold" },
        },
        terminal = {
          a = { fg = colors.blue, bg = colors.bg, gui = "bold" },
        },
        inactive = {
          a = { fg = colors.dim, bg = colors.bg },
          b = { fg = colors.dim, bg = colors.bg },
          c = { fg = colors.dim, bg = colors.bg },
        },
      }

      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

      require("lualine").setup({
        options = {
          theme = tmux_theme,
          component_separators = "",
          section_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = {
            {
              "mode",
            },
          },
          lualine_b = { "diff" },
          lualine_c = {},
          lualine_x = {
            "lsp_status",
            {
              pi.status,
            },
          },
          lualine_y = {
            {
              "diagnostics",
            },
          },
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "aerial" },
      })
    end,
  },

  { "Bekaboo/dropbar.nvim", enabled = false },

  { "nvim-mini/mini.icons" },

  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        format = {
          input = { view = "cmdline_popup" },
          search_down = { view = "cmdline_popup" },
          search_up = { view = "cmdline_popup" },
        },
      },
      presets = {
        lsp_doc_border = true,
      },
      views = {
        hover = {
          size = {
            max_width = 80,
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "NoicePopupBorder",
            },
          },
        },
      },
    },
  },

  { "akinsho/bufferline.nvim", enabled = false },
}
