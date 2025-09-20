---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  enabled = vim.fn.executable("yazi") == 1,
  specs = {
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  },
  event = "VeryLazy",
  keys = {
    {
      "<Leader>e",
      "<cmd>Yazi<cr>",
      desc = "Open Yazi at the current file",
    },
    {
      "<leader>E",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last Yazi session",
    },
  },
  opts = {
    open_multiple_tabs = false,
    floating_window_scaling_factor = {
      height = 1,
      width = 0.9,
    },
    yazi_floating_window_winblend = 0,
    yazi_floating_window_border = "rounded",
    open_for_directories = true,
    keymaps = {
      show_help = "?",
      open_file_in_vertical_split = "<c-v>",
      open_file_in_horizontal_split = "<c-x>",
      open_file_in_tab = "<c-e>",
      grep_in_directory = "<c-s>",
      replace_in_directory = "<c-g>",
      cycle_open_buffers = "<tab>",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
      change_working_directory = "<c-\\>",
    },
    integrations = {
      grep_in_directory = "fzf-lua",
      grep_in_selected_files = "fzf-lua",
    },
    future_features = {
      ya_emit_reveal = true, -- 需要 yazi >= 0.4.0
      ya_emit_open = true, -- 需要 yazi >= 0.4.0
    },
  },
}
