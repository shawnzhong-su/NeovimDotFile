#!filepath init.lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = "helix",
    presets = {}, -- 取消默认的preset
    defaults = {},
    spec = {
      {
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs", icon = { icon = "󰓩 ", color = "magenta" } },
        { "<leader>c", group = "code", icon = { icon = "󰘧 ", color = "blue" } },
        { "<leader>d", group = "debug", icon = { icon = "󰃤 ", color = "red" } },
        { "<leader>dp", group = "profiler", icon = { icon = "󰈚 ", color = "yellow" } },
        { "<leader>f", group = "file/find", icon = { icon = "󰈞 ", color = "blue" } },
        {
          "<leader>a",
          group = "add",
          icon = { icon = "󰐕", color = "blue" }, -- Nerd Font 图标 (nf-md-plus)
        },
        { "<leader>g", group = "git", icon = { icon = "󰊢 ", color = "orange" } },
        { "<leader>gh", group = "hunks", icon = { icon = "󰆢 ", color = "orange" } },
        { "<leader>q", group = "quit/session", icon = { icon = "󰗼 ", color = "red" } },
        { "<leader>s", group = "search", icon = { icon = "󰍉 ", color = "purple" } },
        { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
        { "[", group = "prev", icon = { icon = "󰒮 ", color = "blue" } },
        { "]", group = "next", icon = { icon = "󰒭 ", color = "blue" } },
        { "g", group = "goto", icon = { icon = "󰏢 ", color = "teal" } },
        { "gs", group = "surround", icon = { icon = "󰽛 ", color = "yellow" } },
        { "z", group = "fold", icon = { icon = "󰘖 ", color = "cyan" } },
        {
          "<leader>b",
          group = "buffer",
          icon = { icon = "󰓩 ", color = "green" },
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          icon = { icon = "󰖮 ", color = "blue" },
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        -- better descriptions
        { "gx", desc = "Open with system app" },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    if not vim.tbl_isempty(opts.defaults) then
      LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
      wk.register(opts.defaults)
    end
  end,
}
