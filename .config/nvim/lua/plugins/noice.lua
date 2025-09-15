---@type LazySpec
return {
  {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      { "MunifTanjim/nui.nvim", lazy = true },
    },
    specs = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
          if opts.ensure_installed ~= "all" then
            opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "regex", "vim" })
          end
        end,
      },
      {
        "rebelot/heirline.nvim",
        optional = true,
        opts = function(_, opts)
          local noice_opts = require("astrocore").plugin_opts "noice.nvim"
          if vim.tbl_get(noice_opts, "lsp", "progress", "enabled") ~= false then -- check if lsp progress is enabled
            opts.statusline[9] = require("astroui.status").component.lsp { lsp_progress = false }
          end
        end,
      },
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        lsp = {
          hover = {
            -- Use default hover doc window instead of this
            -- WARN: hover scroll won't work anymore, see https://github.com/neovim/neovim/issues/27288
            -- Should firstly jump to hover window, then scroll
            enabled = false,
            silent = true,
          },
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          signature = {
            -- Use blink.cmp for signature help instead of this
            enabled = false,
            auto_open = {
              enabled = true,
              trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
              luasnip = false, -- Will open signature help when jumping to Luasnip insert nodes
              throttle = 50, -- Debounce lsp signature help request by 50ms
            },
            view = nil, -- when nil, use defaults from documentation
            opts = {}, -- merged with defaults from documentation
          },
          message = {
            enabled = true,
            view = "mini",
            opts = {},
          },
        },
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        routes = {
          { filter = { event = "msg_show", find = "DB: Query%s" }, opts = { skip = true } },
          { filter = { event = "msg_show", find = "%swritten" }, opts = { skip = true } },
          { filter = { event = "msg_show", find = "%schange;%s" }, opts = { skip = true } },
          { filter = { event = "msg_show", find = "%s已写入" }, opts = { skip = true } },
          { filter = { event = "msg_show", find = ".*行发生改变.*" }, opts = { skip = true } },
          { filter = { event = "msg_show", find = ".*fewer lines" }, opts = { skip = true } },
          { filter = { event = "msg_show", find = ".*vim.tbl_islist is deprecated.*" }, opts = { skip = true } },
          {
            filter = { event = "msg_show", find = '.*Run ":checkhealth vim.deprecated".*' },
            opts = { skip = true },
          },
          {
            filter = { event = "msg_show", find = "%-32603: Invalid offset" },
            opts = { skip = true },
          },
        },
      })
    end,
  },
}
