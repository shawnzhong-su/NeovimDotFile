-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Show the latest diagnostics for the current cursor position in a floating window.
-- Reference: :h vim.diagnostic.open_float
local diag_float = vim.api.nvim_create_augroup("UserDiagnosticFloat", { clear = true })

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = diag_float,
  desc = "Show diagnostics in a floating window",
  callback = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local lnum = cursor[1] - 1
    if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
      return
    end

    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "if_many",
      scope = "cursor",
    })
  end,
})
