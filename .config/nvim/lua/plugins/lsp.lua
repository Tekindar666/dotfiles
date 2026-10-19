return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
      },
      completion = {
        menu = {
          auto_show_delay_ms = 200,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = false,
        },
      },
      signature = {
        enabled = false,
      },
      cmdline = {
        completion = {
          menu = {
            draw = {
              columns = {
                { "label", "label_description", gap = 1 },
              },
            },
          },
          ghost_text = {
            enabled = false,
          },
        },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "shellcheck",
        "shfmt",
        "jdtls",
        "checkstyle",
        "oxlint",
        "oxfmt",
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      events = { "BufWritePost" },
      linters_by_ft = {
        javascript = { "oxlint" },
        javascriptreact = { "oxlint" },
        markdown = {},
        typescript = { "oxlint" },
        typescriptreact = { "oxlint" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      diagnostics = {
        virtual_text = false,
        underline = true,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
            [vim.diagnostic.severity.WARN] = "DiagnosticLineNrWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticLineNrInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticLineNrHint",
          },
        },
        float = { border = "rounded" },
      },
      servers = {
        eslint = { enabled = false },
        vtsls = { enabled = false },
        tsgo = {},
      },
    },
  },
  -- NOTE: nvim-cmp config commented out in favor of LazyVim's default blink.cmp.
  -- Uncomment the block below (and add { "saghen/blink.nvim", enabled = false }) to restore.
  --
  -- {
  --   "hrsh7th/nvim-cmp",
  --   enabled = true,
  --   event = "InsertEnter",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-path",
  --     "hrsh7th/cmp-cmdline",
  --     {
  --       "L3MON4D3/LuaSnip",
  --       version = "v2.*",
  --       build = "make install_jsregexp",
  --     },
  --     "saadparwaiz1/cmp_luasnip",
  --     "rafamadriz/friendly-snippets",
  --     "onsails/lspkind.nvim",
  --   },
  --   config = function()
  --     local cmp = require("cmp")
  --     local luasnip = require("luasnip")
  --     local lspkind = require("lspkind")
  --     require("luasnip.loaders.from_vscode").lazy_load()
  --
  --     cmp.setup({
  --       completion = {
  --         completeopt = "menu,menuone,preview,noselect",
  --       },
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       mapping = cmp.mapping.preset.insert({
  --         ["<C-j>"] = cmp.mapping.select_next_item(),
  --         ["<C-k>"] = cmp.mapping.select_prev_item(),
  --         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-f>"] = cmp.mapping.scroll_docs(4),
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<C-e>"] = cmp.mapping.abort(),
  --         ["<CR>"] = cmp.mapping.confirm({ select = false }),
  --         ["<Tab>"] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             cmp.select_next_item()
  --           elseif luasnip.expand_or_jumpable() then
  --             luasnip.expand_or_jump()
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --         ["<S-Tab>"] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             cmp.select_prev_item()
  --           elseif luasnip.jumpable(-1) then
  --             luasnip.jump(-1)
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --       }),
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" },
  --         { name = "luasnip" },
  --         { name = "buffer" },
  --         { name = "path" },
  --       }),
  --       window = {
  --         completion = cmp.config.window.bordered({
  --           winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
  --         }),
  --         documentation = cmp.config.window.bordered({
  --           winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
  --         }),
  --       },
  --       formatting = {
  --         format = lspkind.cmp_format({
  --           mode = "symbol_text",
  --           maxwidth = 50,
  --           ellipsis_char = "...",
  --         }),
  --       },
  --     })
  --
  --     cmp.setup.cmdline("/", {
  --       mapping = cmp.mapping.preset.cmdline({
  --         ["<C-n>"] = cmp.mapping.select_next_item(),
  --         ["<C-p>"] = cmp.mapping.select_prev_item(),
  --         ["<M-Space>"] = cmp.mapping.complete(),
  --         ["<Tab>"] = cmp.mapping.confirm({ select = true }),
  --       }),
  --       sources = {
  --         { name = "buffer" },
  --       },
  --     })
  --
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline({
  --         ["<C-n>"] = cmp.mapping.select_next_item(),
  --         ["<C-p>"] = cmp.mapping.select_prev_item(),
  --         ["<M-Space>"] = cmp.mapping.complete(),
  --         ["<Tab>"] = cmp.mapping.confirm({ select = true }),
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --       }),
  --       sources = cmp.config.sources({
  --         { name = "path" },
  --         { name = "cmdline" },
  --       }),
  --       completion = {
  --         completeopt = "menu,menuone,noselect",
  --       },
  --     })
  --   end,
  -- },
}
